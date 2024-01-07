# see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# NOTE small impact on speed, even when not in a git folder
function _git_status_for_prompt {
    # could use 'timeout --kill-after=0.01s 0.01s cmd' to stop git info when it takes too long on a slow filesystem
    if [[ $(pwd -P) == /efs/* ]]; then
        # NOTE above takes any pattern, so something|otherthing|morestuff works instead of a list
        echo ' %F{3}󰏥%f'
        return
    fi
    # NOTE plain 'git status' with no arguments can be slow because it checks all submodules
    # NOTE parsing like below is actually 2x faster than zsh's vcs_info
    # NOTE --porcelain=v1 would be preferred, but then --show-stash is ignored
    # NOTE some utf8 icons only worked when in tmux, double-check when using new ones
    # theme: 󰏥   󰅚󰆗󰙝󰄴 󰊰 
    # theme: 󰏥  󰛃󰛀󰅗 󰄳 󰈙 
    local args=(--branch --ignore-submodules=all --untracked-files=normal --ahead-behind --show-stash)
    (git -c advice.statusHints=false status $args |& awk -v ORS='' '
        BEGIN { has=1; flags=0; stashed=0; print " %F{3}" }
        /^fatal: not a git repository/ { has=0 }
        /^On branch / { print " " $3 " " }
        /^HEAD detached at / { print " " $4 " " }
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
            if (has==0) print ""
            if (has==1 && flags==0) print "󰄴"
            if (has==1 && stashed==1) print " 󰊰"
            print "%f"
        }
    ') || true
}


# enable expansions for prompts like PS1
setopt prompt_subst  # apply typical expansions like: $, ${, $(, ((, ...
setopt prompt_percent  # apply expansions for "%"


function {
    # NOTE generally anything that needs subshells slows down the prompt
    # get full timings using > time zsh -ic 'time ( print -P $PS1 )'
    local n=$'\n'
    local alerts='%(?,,%F{1}%Sexit code = %?'$n'%s%f)'
    local headers=(
        '%K{0}'  # background color for the header line
        ' %F{4}%B%40<…<%~%<<%b%f'  # current folder (truncated if long)
        '$(_git_status_for_prompt)'
    )
    headers+=(
        '%F{4}${VIRTUAL_ENV:+ }%f'  # virtual env
        '%(1j, %F{1}%j&%f,)'  # background jobs
        '%E%k'  # fill to end of line
    )
    local edit='%F{15}${${${KEYMAP:-main}/vicmd/N}/(main|viins)/I}>%f '
    local prompt_marker=']133;A\'
    PS1=$prompt_marker$n$alerts$n${(j//)headers}$n$edit
}


# see 'man zshzle' for reporting the current vim mode
function zle-keymap-select() {
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select


## easier output for when using 'set -x'
# we show "[context/trace]" with faint color and on its own line
# and then indented the expanded line
# this way it should be easy to skip/ignore and understand what is the actual output
# but we cannot color the actual expansion :/ because there is no PS4_after or similar
# '[%x:%I %e]' might sometimes be more useful? not sure when it's different from the more default below
PS4='%K{0}%F{10}[%N:%i %_]
    %f%k %F{4}%f '


export PS1 PS4
