{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.profiles.desktop.dwm;

  xinitrc = pkgs.writeText ".xinitrc"
    ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      feh --bg-scale $HOME/Downloads/mountains.jpg

      dwm
    '';
in
{
  options.dots.profiles.desktop.dwm = {
    enable = mkEnableOption "dwm profile";
  };

  config = mkIf cfg.enable {
    home.file.".xinitrc".source = xinitrc;
  };
}
