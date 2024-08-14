{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    geeqie
    google-chrome
    protonmail-desktop
    roam-research
    spotify
    syncthing
  ];

  dots = {
    profiles = {
      dwm.enable = true;
      linux.enable = true;
    };
    alacritty = {
      enable = true;
      font_size = 12.0;
      font_normal = "Zed Mono Nerd Font";
    };
    osh.enable = true;
  };
}
