{ ... }:

{
  home.stateVersion = "24.05";

  dots = {
    profiles = {
      darwin.enable = true;
    };
    alacritty = {
      enable = true;
      font_size = 17.0;
      font_normal = "ZedMono Nerd Font";
    };
    osh.enable = true;
    kmonad.enable = true;
  };
}
