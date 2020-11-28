autoload -Uz colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'

need_push () {
  up=$(/usr/bin/git cherry -v @{upstream} 2>/dev/null) || return
  if [[ $up == "" ]]
  then
    echo " "
  else
    echo " with %F{magenta}%Bunpushed%b "
  fi
}

directory_name(){
  echo "%F{cyan}%1/%\/%f"
}

export PROMPT=$'
%(?,,%F{red}%?%f)
%F{cyan}%n%f in $(directory_name) ${vcs_info_msg_0_}$(need_push) %(1j,%F{red}%j&%f,) %E
› '

precmd() {
  title "zsh" "%m" "%55<...<%~"

  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
    zstyle ':vcs_info:git*' formats 'on %F{green}%b%f%F{red}%u%c%f'
  } else {
    zstyle ':vcs_info:git*' formats 'on %F{red}%b%f%F{red}%u%c%f'
  }

  vcs_info
}
