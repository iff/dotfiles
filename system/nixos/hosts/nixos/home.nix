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
    alacritty.enable = true;
    alacritty.font_size = 10.0;
    osh.enable = true;
  };
}
