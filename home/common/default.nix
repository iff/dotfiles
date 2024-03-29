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
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" "Iosevka" ]; })
  ];

  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
  };


  home.file.".lesskey".text =
    ''
      #command
      e forw-line
      u back-line
      n left-scroll
      i right-scroll
      h forw-screen
      H forw-forever
      ^h goto-end
      k back-screen
      ^k goto-line
      r repaint
      E repeat-search
      U reverse-search
      ff clear-search
    '';

}
