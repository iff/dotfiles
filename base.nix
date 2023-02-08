{ pkgs, ... }: {
  home.stateVersion = "22.11";

  # TODO: https://nix-community.github.io/home-manager/#sec-install-nixos-module
  # do we need to set?:
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    # FIXME: move to module mkMerge config for Darwin/Linux
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
  home.file."bin/git-ssh-dispatch".source = ./bin/git-ssh-dispatch;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
}
