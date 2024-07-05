{ config, inputs, pkgs, lib, ... }:

with lib;
let
  cfg = config.dots.kmonad;

  kmonad_agent = builtins.readFile ./kmonad/org.kmonad.agent.plist;
  install-kmonad-service = pkgs.writeScriptBin "install-kmonad-service"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      sudo echo ${kmonad_agent} > /Library/LaunchDaemons/org.kmonad.agent.plist
      sudo chown root:wheel /Library/LaunchDaemons/org.kmonad.agent.plist
      sudo launchctl bootstrap system /Library/LaunchDaemons/org.kmonad.agent.plist
      echo 'add kmonad exec to Input Monitoring'
    '';

  uninstall-kmonad-service = pkgs.writeScriptBin "uninstall-kmonad-service"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      sudo launchctl bootout system /Library/LaunchDaemons/org.kmonad.agent.plist
      sudo rm /Library/LaunchDaemons/org.kmonad.agent.plist
    '';
in
{
  options.dots.kmonad = {
    enable = mkEnableOption "enable kmonad";
  };

  config = mkIf cfg.enable {
    home.packages = [ install-kmonad-service uninstall-kmonad-service ];
    # needs https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice (v3.1.0)
    # home.packages = [ inputs.kmonad.packages.${pkgs.system}.default ];
    home.file.".config/kmonad/config.kbd".source = ./kmonad/config.kbd;
  };
}
