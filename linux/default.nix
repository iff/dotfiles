{ pkgs, ... }:

let
  sshot = pkgs.writeScriptBin "sshot"
    ''
      #!/bin/zsh
      set -eux -o pipefail

      mkdir -p ~/sshots
      sleep 0.2s
      scrot ~/sshots/'%Y-%m-%d--%H:%M:%S.png' --silent --exec 'gthumb $f'
    '';
  susp = pkgs.writeScriptBin "susp"
    ''
      #!/bin/zsh
      slock &
      systemctl suspend
    '';
in
{
  # targets.genericLinux.enable = true;

  home.packages = [
    sshot
    susp
    pkgs.redshift
  ];

  services = {
    redshift = {
      enable = true;
      temperature = {
        day = 5700;
        night = 3200;
      };
      provider = "manual";
      latitude = 47.4;
      longitude = 8.5;
      settings = {
        redshift.adjustment-method = "randr";
        redshift.transition = 1;
        redshift.brightness-day = 1.0;
        redshift.brightness-night = 0.7;
      };
    };
  };
}
