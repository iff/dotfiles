unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt auto_remove_slash

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

zstyle ':completion:*' verbose yes
# TODO * vs *:default, unclear, both should work?
zstyle ':completion:*:default' menu select
# TODO more about this in zsh/complist modules with ZLS_COLORS and
# also probably overwritten further down from omz copy
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' special-dirs true

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# go back to a named parent folder, or one up if no name given
function .. {
   if [[ -v 1 ]]; then
      local x
      x=$(pwd)
      x=${x:h}
      until [[ ${x:t} == $1 || $x == / ]]; do
         x=${x:h}
      done
      if [[ $x == / ]]; then
         echo 'cannot find a parent folder named' $1
      else
         cd $x
      fi
   else
      cd ..
   fi
}
function _complete_.. {
   reply=$(pwd)
   reply=(${(s|/|)reply})
}
compctl -K _complete_.. ..

function _complete_tm {
   reply=$(tmux list-sessions -F '#{session_name}')
   reply=(${(f)reply})
}
compctl -K _complete_tm tm

# zmodload zsh/complist
# autoload -U compinit
# compinit -d ~/.zcompdump
