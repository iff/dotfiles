{ lib, pkgs, ... }:

let
  tmux-bind-g = pkgs.writeScriptBin "tmux-bind-g"
    ''
      #!/bin/zsh
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

      # confirm before killing a window or the server
      bind-key k confirm kill-window
      bind-key K confirm kill-server

      bind-key Space choose-tree

      # Reload the file with Prefix r.
      bind r source-file ~/.tmux.conf

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

      # fix paths for new windows
      bind c new-window -c "#{pane_current_path}"

      setw -g mode-keys vi

      # Splitting panes.
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # xmonad likeish
      bind h resize-pane -L 5
      bind j resize-pane -D 5
      bind k resize-pane -U 5
      bind l resize-pane -R 5

      # Moving between windows.
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      set-option -sa terminal-features 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'
      set-option -sa terminal-overrides 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'
    '';
  };


}
