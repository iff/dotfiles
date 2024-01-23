{ lib, pkgs, ... }:

let
  tmux-bind-g = pkgs.writeScriptBin "tmux-bind-g"
    ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      # bind an executable to g (split) and G (new window)
      # meant to use dynamically for whatever is the current task
      # at the end
      #   [q] to exit
      #   [enter] to rerun

      # NOTE alternatively, we put the command in a file? less escape problems?
      cmd='while true; do clear; echo ">" '$@'; echo; '$@'; echo; echo ">" '$@' ; read -sk "r?exit code = $? [q or any]"; if [[ $r == q ]]; then break; fi; done'
      tmux bind-key g split-window -h -c "#{pane_current_path}" zsh -ic $cmd
      tmux bind-key G new-window -n g-bound -c "#{pane_current_path}" zsh -ic $cmd
    '';
in
{
  # FIXME alacritty and TMUX have issues with OSX native ncurses
  # see https://github.com/NixOS/nixpkgs/issues/204144
  home.packages = [
    tmux-bind-g
  ] ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.ncurses ];

  programs.tmux = {
    enable = true;
    prefix = "`";
    baseIndex = 1;
    historyLimit = 5000;
    escapeTime = 0;

    extraConfig = ''
      # forward focus events
      set -g focus-events on

      set-option -g renumber-windows on

      set -g status-position top
      set -g status-left-length 32
      set -g status-right-length 150

      set-option -g status-bg "#3c3836"
      set-option -g status-fg "#d5c4a1"
      # set-option -g status-attr default

      # default window title colors
      set-option -g window-status-style 'fg=#d5c4a1,bg=default'

      # active window title colors
      set-option -g window-status-current-style 'fg=#fbf17c,bg=#504945'

      # pane border
      set-option -g pane-border-style 'fg=#d65d0e'
      set-option -g pane-active-border-style 'fg=#d65d0e'

      # message text
      # set-option -g message-bg "#2b303b"
      # set-option -g message-fg "#c0c5ce"

      # pane number display
      set-option -g display-panes-active-colour "#a3be8c"
      set-option -g display-panes-colour "#ebcb8b"

      # clock
      set-window-option -g clock-mode-colour "#fbf17c"

      # bell
      set-window-option -g window-status-bell-style fg="#2b303b",bg="#bf616a"

      # status bar
      set -g status-left ' #S |'
      set -g window-status-format " #I #W "
      set -g window-status-current-format " #I *#W "
      set -g status-right "" # '%A %m/%d %l:%M %p'

      set-option -sa terminal-features 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'
      set-option -sa terminal-overrides 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'

      # keybindings

      # unbind all
      unbind -a -T prefix
      unbind -a -T root
      unbind -a -T copy-mode
      unbind -a -T copy-mode-vi

      setw -g mode-keys vi
      set-option -g status-keys vi

      # reload tmux conf
      bind r source-file ~/.config/tmux/tmux.conf
      bind d detach-client

      bind BSpace new-window -c "#{pane_current_path}"
      bind Enter split-window -h -c "#{pane_current_path}"
      bind Tab split-window -v -c "#{pane_current_path}"

      # confirm before killing a window or the server
      bind g confirm kill-window

      # navigate tmux sessions
      bind Space new-window zsh -c 'tmux list-session | cut -d : -f 1 | fzf --bind "enter:become(tmux switch -t {})"'

      # pane selection
      bind ` display-panes

      # some movement
      bind-key h last-window
      bind-key k last-pane
      bind -r m select-window -t :-
      bind -r o select-window -t :+

      # fullscreen pane
      bind-key . resize-pane -Z
      # move to new window
      bind-key , break-pane

      bind a copy-mode
      bind -T copy-mode-vi u send-keys -X cursor-up
      bind -T copy-mode-vi n send-keys -X cursor-left
      bind -T copy-mode-vi i send-keys -X cursor-right
      bind -T copy-mode-vi m send-keys -X start-of-line
      bind -T copy-mode-vi o send-keys -X end-of-line
      bind -T copy-mode-vi h send-keys -X page-down
      bind -T copy-mode-vi k send-keys -X page-up
      bind -T copy-mode-vi C-h send-keys -X history-bottom
      bind -T copy-mode-vi C-k send-keys -X history-top
      bind -T copy-mode-vi C-u send-keys -X previous-prompt
      bind -T copy-mode-vi C-e send-keys -X next-prompt
      bind -T copy-mode-vi Escape send-keys -X cancel
    '';
  };

}
