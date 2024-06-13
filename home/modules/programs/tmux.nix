{ lib, pkgs, ... }:

{
  # FIXME alacritty and TMUX have issues with OSX native ncurses
  # see https://github.com/NixOS/nixpkgs/issues/204144
  home.packages = [ ] ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.ncurses ];

  programs.tmux = {
    enable = true;
    prefix = "`";
    baseIndex = 1;
    historyLimit = 5000;
    escapeTime = 0;
    terminal = "tmux-256color";

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

      bind ';' command-prompt
      bind d detach-client

      bind BSpace new-window -c "#{pane_current_path}"
      bind Enter split-window -h -c "#{pane_current_path}"
      bind Tab split-window -v -c "#{pane_current_path}"

      # confirm before killing a window or the server
      bind g confirm kill-window

      # navigate tmux sessions
      bind-key Space new-window zsh -c "tmux list-sessions -F '#{session_name}' | fzf --preview-window=down,30% --preview 'tmux list-windows -t {}' --bind 'enter:become(tmux switch -t {})+abort'"

      # pane selection
      bind ` display-panes

      # windows
      bind-key 1 select-window -t :1
      bind-key 2 select-window -t :2
      bind-key 3 select-window -t :3
      bind-key 4 select-window -t :4
      bind-key 5 select-window -t :5
      bind-key 6 select-window -t :6
      bind-key 7 select-window -t :7
      bind-key 8 select-window -t :8
      bind-key 9 select-window -t :9

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
      bind -T copy-mode-vi e send-keys -X cursor-down
      bind -T copy-mode-vi m send-keys -X start-of-line
      bind -T copy-mode-vi o send-keys -X end-of-line
      bind -T copy-mode-vi h send-keys -X page-down
      bind -T copy-mode-vi k send-keys -X page-up
      bind -T copy-mode-vi C-h send-keys -X history-bottom
      bind -T copy-mode-vi C-k send-keys -X history-top
      bind -T copy-mode-vi C-u send-keys -X previous-prompt
      bind -T copy-mode-vi C-e send-keys -X next-prompt
      bind -T copy-mode-vi Escape send-keys -X cancel

      # bind-key g switch-client -Trunners
      # bind-key -Trunners g split-window -h zsh -i .tmux/g
    '';
  };

}
