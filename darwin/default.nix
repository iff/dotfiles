{ pkgs, ... }: {
  home.username = "iff";
  home.homeDirectory = "/Users/iff";

  home.packages = [
    pkgs.ncurses
  ];
}
