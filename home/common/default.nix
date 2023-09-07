{ pkgs, ... }:

{
  home.stateVersion = "23.05";

  # TODO: https://nix-community.github.io/home-manager/#sec-install-nixos-module
  # do we need to set?:
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;

  programs.home-manager.enable = true;
  manual.manpages.enable = true; # home-manager man pages
  programs.man.enable = true; # nix pkgs man pages

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.direnv
    pkgs.dua
    pkgs.eza
    pkgs.fd
    pkgs.jq
    pkgs.nix-direnv
    pkgs.procs
    # fonts
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

