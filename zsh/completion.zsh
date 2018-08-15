# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# go back to a parent folder (default first parent)
.. () {
        1=${1:-$(basename $(dirname $(pwd)))}
        while [[ $(basename $(pwd)) != $1 ]]; do
                cd ..
        done
}
_complete_.. () {
        reply=$(pwd)
        reply=(${(s|/|)reply})
}
compctl -K _complete_.. ..
