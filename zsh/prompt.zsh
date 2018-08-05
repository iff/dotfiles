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
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n%{$fg_bold[yellow]%}%n%{$reset_color%} in $(directory_name) ${vcs_info_msg_0_}$(need_push)\n› '

precmd() {
  title "zsh" "%m" "%55<...<%~"

  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
    zstyle ':vcs_info:git*' formats 'on %F{green}%b%f%u%c'
  } else {
    zstyle ':vcs_info:git*' formats 'on %F{red}%b%f%u%c'
  }

  vcs_info

  set_prompt
}
