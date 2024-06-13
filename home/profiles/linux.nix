{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.profiles.linux;

  sshot = pkgs.writeScriptBin "sshot"
    ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      mkdir -p ~/sshots
      sleep 0.2s
      scrot ~/sshots/'%Y-%m-%d--%H:%M:%S.png' --silent --exec 'gthumb $f'
    '';
  susp = pkgs.writeScriptBin "susp"
    ''
      #!/usr/bin/env zsh
      slock &
      systemctl suspend
    '';
  lvm-overview = pkgs.writeScriptBin "lvm-overview"
    ''
      #!/usr/bin/python3

      # show hierarchically vg/lv/pv
      # for pv every segment is shown
      # so a lv could contain the same pv child multiple times
      # all info is from 'lvm fullreport --reportformat=json'
      # see also 'lsblk -s' and 'lsblk -p' for useful data

      import json
      from subprocess import run

      reply = run(
          ["sudo", "lvm", "fullreport", "--reportformat=json"],
          capture_output=True,
          check=True,
      )
      fullreport = json.loads(reply.stdout)
      for i, report in enumerate(fullreport["report"]):
          print(f"[report entry {i}]")
          pv_by_uuid = {pv["pv_uuid"]: pv for pv in report["pv"]}
          for vg in report["vg"]:
              print(f"  {vg['vg_name']}:")
              for lv in report["lv"]:
                  print(f"    {lv['lv_name']}: {lv['lv_size']}")
                  for pvseg in report["pvseg"]:
                      if pvseg["lv_uuid"] != lv["lv_uuid"]:
                          continue
                      print(f"      {pv_by_uuid[pvseg['pv_uuid']]['pv_name']}")
    '';
  loop = pkgs.writeScriptBin "loop"
    ''
      #!/usr/bin/env zsh
      set -eux -o pipefail

      while true; do 
        clear
        echo ">" $@
        echo
        $@
        echo
        echo ">" $@
        read -sk "r?exit code = $? [q or any]"
        if [[ $r == q ]]; then 
          break
        fi
      done
    '';
in
{
  options.dots.profiles.linux = {
    enable = mkEnableOption "linux profile";
  };

  config = mkIf cfg.enable {
    # targets.genericLinux.enable = true;

    home.packages = [
      loop
      lvm-overview
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
  };
}
