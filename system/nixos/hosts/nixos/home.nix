{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pkgs.geeqie
    # TODO
  ];

  dots = {
    alacritty.enable = true;
    alacritty.font_size = 12.0;
  };
}
