{ pkgs, ... }:

{
  home.packages = with pkgs; [
    geeqie
    google-chrome
    roam-research
    # busybox
    # vscode
  ];

  services.syncthing.enable = true;

  dots = {
    # profiles = {
    #   hyprland.enable = true;
    # };
    # FIXME only for dwm
    profiles = {
      dwm.enable = true;
      linux.enable = true;
    };
    alacritty.enable = true;
    # FIXME depends on dwm/hypr?
    alacritty.font_size = 12.0;
    ltstatus.enable = true;
  };
}
