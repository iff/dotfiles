{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    geeqie
    google-chrome
    roam-research
    spotify
    syncthing
  ];

  dots = {
    profiles = {
      sway.enable = true;
    };
    alacritty = {
      enable = true;
      font_size = 10.0;
      # font_normal = "Zed Mono Nerd Font";
      font_normal = "Iosevka Nerd Font";
    };
    osh.enable = true;
  };
}
