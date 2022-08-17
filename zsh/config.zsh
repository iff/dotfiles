export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# use the directory stack for normal cd commands
setopt auto_pushd
# invert +/- for the directory stack (so "cd -2" jumps to the second last dir)
setopt pushd_minus
# ignore duplicates on the directory stack
setopt pushd_ignore_dups

# vim mode for zle
bindkey -v
export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)

ZLE_SPACE_SUFFIX_CHARS=$'&|'

# Use vim cli mode
# bindkey '^P' up-history
# bindkey '^N' down-history
# # backspace and ^h working even after
# # returning from command mode
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char
# # ctrl-w removed word backwards
# bindkey '^w' backward-kill-word
# # ctrl-r starts searching history backward
# #bindkey '^r' history-incremental-search-backward
# #bindkey '^r' znt-history-widget
# bindkey '^r' history-search-multi-word # todo not sure why I have to do it here, the plugin does it already, but it doesnt work
# # edit command line in editor
# #bindkey '^x^e' edit-command-line
# bindkey '^R' history-incremental-search-backward

export MANPAGER='nvim +Man!'
export VISUAL=nvim
export EDITOR=nvim
