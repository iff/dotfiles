# dkuettels async prompt
function prompt_compute {

    if [[ $(pwd -P) == (/efs|/efs/*|/s3/*) ]]; then
        print -- 'prompt_state=󰒲'
        # echo '󰏥'
        return
    fi

    local git_path
    if git_path=$(git rev-parse --show-toplevel); then
        if [[ $git_path != $(pwd) ]]; then
            print -- 'prompt_path=%F{4}%B\e[4m'${git_path/#$HOME/\~}'\e[0m%b/'$(realpath --relative-to=$git_path $(pwd))'%f'
        fi
        # NOTE plain 'git status' with no arguments can be slow because it checks all submodules
        # NOTE parsing like below is actually 2x faster than zsh's vcs_info
        # NOTE --porcelain=v1 would be preferred, but then --show-stash is ignored
        local args=(--branch --ignore-submodules=all --untracked-files=normal --ahead-behind --show-stash)
        print -n -- "prompt_git='"
        # could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
        (git -c advice.statusHints=false status $args |& awk -v ORS='' '
            BEGIN { has=1; flags=0; stashed=0; print " %F{3}" }
            /^fatal: not a git repository/ { has=0 }
            /^On branch / { print " " $3 " " }
            /^HEAD detached at / { print " " $4 " " }
            /^Your branch is up to date with / { }
            /^Your branch is ahead of / { print " " }
            /^Your branch is behind / { print " " }
            /^Your branch and .+ have diverged/ { print " " }
            /^nothing to commit, working tree clean/ { }
            /^Unmerged paths:/ { print "󰅚"; flags++ }
            /^Changes to be committed:/ { print "󰆗"; flags++ }
            /^Changes not staged for commit:/ { print "󰙝"; flags++ }
            /^Untracked files:/ { print ""; flags++ }
            /^Your stash currently has / { stashed=1 }
            END {
                if (has==0) print ""
                if (has==1 && flags==0) print "󰄴"
                if (has==1 && stashed==1) print " 󰊰"
                print "%f"
            }
        ') || true
        print -- "'"
    else
        print -- 'prompt_git='
    fi

    print -- 'prompt_state='
}

zmodload zsh/zpty
zmodload zsh/datetime

function prompt_receive {
    local s
    if zpty -r prompt s; then
        eval $s[1,-3]
        zle reset-prompt
    else
        zle -F $1
        zpty -d prompt
    fi
}
zle -N prompt_receive

function prompt_fork {
    prompt_path='%F{4}%B%~%b%f'
    # TODO consider keeping old but indicate gray out of date?
    prompt_git=''
    prompt_state=' '
    zpty -d prompt &>/dev/null
    zpty prompt prompt_compute
    local fd=$REPLY
    zle -Fw $fd prompt_receive
}

function prompt_before {
    prompt_start=$EPOCHSECONDS
}

autoload -U add-zsh-hook
add-zsh-hook precmd prompt_fork
add-zsh-hook preexec prompt_before

# enable expansion in prompt strings (PS1 & co)
setopt prompt_subst  # apply parameter expansions
setopt prompt_percent  # apply prompt expansions (%)

prompt_marker=']133;A\'  # lets tmux know where new output started
prompt_alerts='%(?,,
%F{1}%Sexit code = %?%s%f)'
prompt_path='%F{4}%B%~%b%f'
prompt_git=''
prompt_jobs='%(1j, %F{1}%j&%f,)'
prompt_state=' '
prompt_venv=''

# 󰫍  󰌒    
export PS1='$prompt_marker$prompt_alerts
$prompt_path$prompt_git$prompt_jobs %E%k
 %F{4}${prompt_venv:$+VIRTUAL_ENV:1}%f %F{15}%f '

export PS4='%K{0}%F{10}[%N:%i %_]
    %f%k %F{4}%f '
