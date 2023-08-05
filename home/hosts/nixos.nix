{ ... }:

{
  home.stateVersion = "23.05";

  dots = {
    profiles = {
      nixos.enable = true;
    };
    alacritty.enable = true;
    alacritty.font_size = 12.0;
  };
}
