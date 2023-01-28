{ pkgs, ... }: {
  home.username = "iff";
  home.homeDirectory = "/Users/iff";

  # FIXME both alacritty and TMUX issue with TERM on OSX
  # https://github.com/NixOS/nixpkgs/issues/204144
  # needs TERM = "xterm-256color";
  # not sure if we can use nix ncurses to fix?
  home.packages = [
    pkgs.ncurses
  ];
}
