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
  home.username = "iff";
  home.homeDirectory = "/home/iff";

  home.packages = [
    sshot
    susp
    pkgs.redshift
  ];

  home.file.".config/redshift.conf".source = ../redshift/redshift.conf;

}
