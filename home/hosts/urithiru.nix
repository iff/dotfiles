{ ... }:

{
  home.stateVersion = "23.05";

  dots = {
    profiles = {
      darwin.enable = true;
    };
    alacritty = {
      enable = true;
      font_size = 16.0;
      # font_normal = "Zed Mono Nerd Font";
      font_normal = "Iosevka Nerd Font";
    };
    osh.enable = true;
  };
}
