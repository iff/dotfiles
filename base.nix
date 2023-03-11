{ pkgs, ... }: {
  home.stateVersion = "22.11";

  # TODO: https://nix-community.github.io/home-manager/#sec-install-nixos-module
  # do we need to set?:
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.direnv
    pkgs.exa
    pkgs.jq
    pkgs.nix-direnv
    # fonts
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

