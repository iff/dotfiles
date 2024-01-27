{ pkgs, ... }:

{
  home.packages = with pkgs; [
    geeqie
    google-chrome
    roam-research
    spotify
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
