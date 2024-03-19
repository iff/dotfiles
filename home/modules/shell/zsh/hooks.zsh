load_late=yes

function zle-line-init {
    if [[ -v load_late ]]; then
        unset load_late
        # slow setups
        # source ~/.zshrc.d/completion.zsh
        # source ~/.zshrc.d/syntax.zsh  # NOTE needs to be sourced last
    fi
    echo -ne "\e[6 q"  # steady beam
}
zle -N zle-line-init

function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
        echo -ne "\e[2 q"  # steady block
    elif [[ $KEYMAP == (viins|main) ]]; then
        # TODO also viopp and visual or something?
        echo -ne "\e[6 q"  # steady beam
    fi
}
zle -N zle-keymap-select

function zle-line-finish {
    echo -ne "\e[2 q"  # steady block
}
zle -N zle-line-finish
