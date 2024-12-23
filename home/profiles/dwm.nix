{ config, lib, pkgs, ... }:

with lib;
let
  dwm-status = pkgs.writeScriptBin "dwm-status"
    ''
      #!/usr/bin/env zsh
      set -eux -o pipefail
      
      status () {
        echo -n "$(date '+%d/%m %H:%M')"
      }
      
      while true
      do
        xsetroot -name "$(status)";
        sleep 1m;
      done
    '';

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
      dwm-status
    ];

    home.file.".xinitrc".text = ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      # monitor never off
      xset -dpms
      xset s off
      setterm --blank 0 --powerdown 0

      feh --bg-scale $HOME/Downloads/mountains.jpg || true
      redshift -r -v & # |& ts '%F %T' >& $HOME/.log-redshift &
      dwm-status &

      dwm
    '';
  };
}
