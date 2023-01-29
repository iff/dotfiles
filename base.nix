{ pkgs, ... }: {
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.alacritty
    pkgs.direnv
    pkgs.exa
    pkgs.git
    pkgs.jq
    pkgs.nix-direnv
    pkgs.tmux
    # fonts
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".gitconfig".source = ./git/gitconfig;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
}
