{ pkgs, ... }: {
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    # FIXME wayland
    # pkgs.alacritty
    pkgs.exa
    pkgs.fzf
    pkgs.git
    pkgs.tmux
    pkgs.redshift
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  home.file.".gitconfig".source = ./git/gitconfig;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  home.file.".config/redshift.conf".source = ./redshift/redshift.conf;
}
