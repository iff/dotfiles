{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pkgs.geeqie
    # pkgs.vscode
  ];

  services.syncthing.enable = true;

  dots = {
    # profiles = {
    #   hyprland.enable = true;
    # };
    alacritty.enable = true;
    alacritty.font_size = 12.0;
  };
}
