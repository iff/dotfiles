{ config, inputs, pkgs, lib, ... }:

with lib;
let
  cfg = config.dots.kanata;

  kanata_agent = builtins.readFile ./kanata/org.kanata.agent.plist;
  install-kanata-service = pkgs.writeScriptBin "install-kanata-service"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      # needs https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice (v3.1.0)
      # see https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/tree/main/dist
      if [[ ! $(defaults read /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/Info.plist CFBundleVersion) == '3.1.0' ]]; then
        echo 'wrong karabiner driver kit version' >&2
        exit 1
      fi

      # fix path/install - assume PATH?
      if ! [ -x "$(command -v ~/bin/kanata)" ]; then
        echo 'error: kanata is not in ~/bin' >&2
        exit 1
      fi

      echo '${kanata_agent}' | sudo tee /Library/LaunchDaemons/org.kanata.agent.plist
      sudo chown root:wheel /Library/LaunchDaemons/org.kanata.agent.plist
      sudo launchctl bootstrap system /Library/LaunchDaemons/org.kanata.agent.plist

      echo 'add kanata exec to Input Monitoring'
    '';

  restart-kanata = pkgs.writeScriptBin "restart-kanata"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      ~/bin/kanata --cfg ~/.config/kanata/config.kbd --check

      sudo launchctl kickstart -k system/org.kanata.agent
    '';

  uninstall-kanata-service = pkgs.writeScriptBin "uninstall-kanata-service"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      sudo launchctl bootout system /Library/LaunchDaemons/org.kanata.agent.plist
      sudo rm /Library/LaunchDaemons/org.kanata.agent.plist
    '';
in
{
  options.dots.kanata = {
    enable = mkEnableOption "enable kanata";
  };

  config = mkIf cfg.enable {
    # in case we ever use it on another platform
    home.packages = [ ] ++ lib.optionals pkgs.stdenv.isDarwin [ install-kanata-service restart-kanata uninstall-kanata-service ];
    home.file.".config/kanata/config.kbd".source = ./kanata/config.kbd;
  };
}
