{ config, lib, ... }:

with lib;
let
  startx = pkgs.writeScriptBin "startx"
    ''
      /run/current-system/sw/bin/startx
    '';
in
{
  config = mkIf (config.dots.profiles.desktop.wm == "dwm") {
    home.packages = [
      # pkgs.redshift
      startx
    ];

    # services = {
    #   redshift = {
    #     enable = true;
    #     temperature = {
    #       day = 5700;
    #       night = 3200;
    #     };
    #     provider = "manual";
    #     latitude = 47.4;
    #     longitude = 8.5;
    #     settings = {
    #       redshift.adjustment-method = "randr";
    #       redshift.transition = 1;
    #       redshift.brightness-day = 1.0;
    #       redshift.brightness-night = 0.7;
    #     };
    #   };
    # };

    # home.file.".xinitrc".source = ./x11/xsession;
  };
}
