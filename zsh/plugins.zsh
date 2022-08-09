source $MYZSH/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
ZSH_HIGHLIGHT_MAXLENGTH=2000

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/cp/cp.plugin.zsh
cpv() {
    rsync -pogbr -hhh --backup-dir="/tmp/rsync-${USERNAME}" -e /dev/null --progress "$@"
}
compdef _files cpv
