{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    geeqie
    gthumb
    google-chrome
    scrot
    slock
    # vscode
  ];

  services.syncthing.enable = true;

  dots = {
    # profiles = {
    #   hyprland.enable = true;
    # };
    # FIXME only for dwm
    profiles = {
      linux.enable = true;
      desktop.dwm.enable = true;
    };
    alacritty.enable = true;
    # FIXME depends on dwm/hypr?
    alacritty.font_size = 12.0;
  };
}
