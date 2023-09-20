{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.profiles.dwm;
in
{
  options.dots.profiles.dwm = {
    enable = mkEnableOption "dwm profile";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dmenu-rs
      feh
      gthumb
      scrot
    ];

    home.file.".xinitrc".text = ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      feh --bg-scale $HOME/Downloads/mountains.jpg

      dwm
    '';
  };
}