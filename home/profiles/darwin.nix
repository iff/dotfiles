{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.profiles.darwin;
in
{
  options.dots.profiles.darwin = {
    enable = mkEnableOption "darwin profile";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      TERMINFO_DIRS = "$HOME/.nix-profile/share/terminfo:$TERMINFO_DIRS";
    };
  };
}
