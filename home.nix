{ pkgs, ... }: {
  home.username = "iff";
  home.homeDirectory = "/home/iff";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = [
    # pkgs.neovim
    # pkgs.exa
    pkgs.fzf
    pkgs.git
    pkgs.tmux
    pkgs.redshift
  ];

  home.file.".gitconfig".source = ./git/gitconfig.symlink;
  home.file.".tmux.conf".source = ./tmux/tmux.conf.symlink;
  home.file.".config/redshift.conf".source = ./redshift/redshift.conf;
}
