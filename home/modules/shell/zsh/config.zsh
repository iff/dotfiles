export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

## misc options
setopt extended_glob
setopt interactive_comments  # allow comments in interactive use
setopt long_list_jobs
setopt no_flow_control  # no ctrl-s and ctrl-q
setopt noautocd  # dont assume an implicit cd prefix for folder names
setopt rm_star_silent  # no confirmation anymore for "rm *"-like

## completion options
setopt always_to_end  # move to end of word after completion
setopt always_to_end  # move to the end of word
setopt auto_menu  # menu on second request
setopt auto_remove_slash  # depending on next character
setopt complete_in_word
setopt no_list_beep  # dont beep on incomplete/ambiguous completion
setopt no_menu_complete  # dont insert first ambiguous match

## directory stack
setopt auto_pushd  # cd does directory stack
setopt pushd_ignore_dups  # dont add duplicates
setopt pushd_minus  # flip + and - meaning when working with stack

## history (partly managed by home-manager)
# HISTFILE=~/.zsh_history
# export HISTSIZE=1000000000  # "forever"
# export SAVEHIST=1000000000  # "forever"
setopt append_history
# setopt extended_history
# setopt hist_expire_dups_first
# setopt hist_ignore_dups  # ignore duplication command history list
# setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
# setopt share_history

# vim mode for zle
bindkey -v
export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)

ZLE_SPACE_SUFFIX_CHARS=$'&|'

autoload -U up-line-or-beginning-search down-line-or-beginning-search insert-files edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N insert-files
zle -N edit-command-line

# vim insert mode for colemak as default
bindkey -A viins main
bindkey -M viins '^u' up-line-or-beginning-search
bindkey -M viins '^e' down-line-or-beginning-search
# TODO this is really cool, start using it
# TODO ctrl-something does not know shift or not
# TODO ^f is mapped later for fzf stuff, need one place to know what is what?
# bindkey -M viins '^f' insert-files
bindkey -M viins '^xf' insert-files
bindkey -M viins '^xe' edit-command-line
bindkey -M viins '^xh' run-help
# TODO currently used by osh, but not for colemak
# shift-enter would be nice ... not sure we can detect it
# alternatively vim-style: \e-se
# bindkey -M viins '^n' vi-open-line-below
# TODO plus there might be a thing that on enter continuation pushes back the lines?

# vim normal mode for colemak (stolen from dk)
function {

    function dk-vi-insert-at-beginning {
        zle vi-first-non-blank
        zle vi-insert
    }
    zle -N dk-vi-insert-at-beginning

    function dk-vi-insert-before-word {
        zle vi-backward-word
        zle vi-insert
    }
    zle -N dk-vi-insert-before-word

    function dk-vi-insert-before-Word {
        zle vi-backward-blank-word
        zle vi-insert
    }
    zle -N dk-vi-insert-before-Word

    function dk-vi-insert-after-word {
        zle vi-forward-word
        zle vi-add-next
    }
    zle -N dk-vi-insert-after-word

    function dk-vi-insert-after-Word {
        zle vi-forward-blank-word
        zle vi-add-next
    }
    zle -N dk-vi-insert-after-Word

    local binds=(

        # navigate
        L vi-backward-blank-word
        n vi-backward-char
        l vi-backward-word
        '^m' vi-beginning-of-line
        o vi-end-of-line
        Y vi-forward-blank-word
        i vi-forward-char
        m vi-first-non-blank
        y vi-forward-word
        # TODO should I use the vi-* versions here?
        # or make history handling completely separate
        # left hand here is often a better flow
        # no vi-* versions for plain line moves
        # u up-line-or-beginning-search
        # e down-line-or-beginning-search
        u up-line
        e down-line
        # TODO any way to just start from an empty mapping anyway?
        # consider options: -m, -rp to remove based on prefix
        # ok I think we make an empty one and bind it to main: bindkey -A mymap main
        # and first an empty one: bindkey -N mymap, or get it from viins? ins needs defaults
        # bindkey -M vicmd -r s

        # insert
        sn vi-insert
        si vi-add-next
        se vi-open-line-below
        su vi-open-line-above
        sm dk-vi-insert-at-beginning
        so vi-add-eol
        sl dk-vi-insert-before-word
        sL dk-vi-insert-before-Word
        sy dk-vi-insert-after-word
        sY dk-vi-insert-after-Word
        p vi-replace-chars

        # change (see viopp below)
        r vi-change

        # delete (see viopp below)
        d vi-delete
        x vi-delete-char

        # history
        '^u' up-line-or-beginning-search
        '^e' down-line-or-beginning-search

        # miscellaneous
        '^xe' edit-command-line

    )

    bindkey -N vicmd
    bindkey -M vicmd $binds

    function dk-opp-line {
        CURSOR=0
        MARK=$#BUFFER
    }
    zle -N dk-opp-line

    function dk-opp-eol {
        MARK=$#BUFFER
    }
    zle -N dk-opp-eol

    local binds=(
        # TODO select-a-word includes trailing spaces
        # TODO select-a-shell-word refers to a full argument :)
        # TODO zsh actually has argument text objects, and surround-and-escape stuff :)
        n dk-opp-line
        e select-in-word
        E select-in-blank-word
        i dk-opp-eol
    )

    bindkey -N viopp
    bindkey -M viopp $binds
}

export MANPAGER='nvim +Man!'
export VISUAL=nvim
export EDITOR=nvim
export SUDO_EDITOR=nvim

LESS=''
LESS+='--status-column '  # mark matched lines on the left side
LESS+='--HILITE-UNREAD '  # mark next unread line (not working with --status-column?)
LESS+='--RAW-CONTROL-CHARS '  # pass ansi colors
LESS+='--chop-long-lines '  # don't wrap long lines
# LESS+='--clear-screen '  # so that the view starts at the top always
# LESS+='--no-init '  # don't clear the screen after exit
LESS+='--jump-target=.3 '  # the target (for example when searching) is put at 1/3 from the top
export LESS

## FZF

export FZF_DEFAULT_OPTS='--bind=ctrl-e:down,ctrl-u:up,ctrl-g:jump-accept'

# git branches
function __fzf_branch () {
    function branches () {
        # local branches
        git branch --format '%(refname:short)'
        # remote branches that look like local branches
        git branch --remotes --format '%(refname:lstrip=3)'
        # remote branches
        git branch --remotes --format '%(refname:short)'
    }
    if local branch=$(branches | sort | uniq | fzf); then
        LBUFFER="${LBUFFER}$branch"
    fi
    zle reset-prompt
}
zle -N __fzf_branch
bindkey '^fb' __fzf_branch


# items from git status
function __fzf_git () {
    # TODO this also lists already added files, maybe thats okay, lets see how it goes
    if local files=$(git status --short | fzf --nth=2.. --multi | awk -v ORS=' ' 'match($0, /.. (.*)/, m) { print m[1] }'); then
        # TODO not sure if we need some ${=files} or ${(f)files} for proper escaping?
        LBUFFER="${LBUFFER}$files"
    fi
    zle reset-prompt
}
zle -N __fzf_git
bindkey '^fg' __fzf_git


# insert files and folders
function __fzf_files {
    if local f=$(fd | fzf --layout=reverse --height=50% --preview='file {}; echo; cat {}'); then
        LBUFFER+=$f
    fi
    zle reset-prompt
}
zle -N __fzf_files
bindkey '^t' __fzf_files


# change directory
function __fzf_cd {
    if local d=$(fd --type=directory | fzf --layout=reverse --height=50% --preview='eza --header --git --time-style=long-iso --icons --no-permissions --no-user --long --sort=name {}'); then
        cd $d
    fi
    zle reset-prompt
}
zle -N __fzf_cd
bindkey '^g' __fzf_cd
