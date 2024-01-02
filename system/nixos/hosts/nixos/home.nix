{ pkgs, ... }:

{
  home.packages = with pkgs; [
    geeqie
    google-chrome
    roam-research
    spotify
    # busybox
    # vscode
  ];

  # services.syncthing.enable = true;

  dots = {
    profiles = {
      sway.enable = true;
    };
    # FIXME only for dwm
    # profiles = {
    #   dwm.enable = true;
    #   linux.enable = true;
    # };
    alacritty.enable = true;
    # FIXME depends on dwm/hypr?
    alacritty.font_size = 10.0;
    ltstatus.enable = true;
    osh.enable = true;
  };
}
