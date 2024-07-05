{ config, inputs, pkgs, lib, ... }:

with lib;
let
  cfg = config.dots.kmonad;
in
{
  options.dots.kmonad = {
    enable = mkEnableOption "enable kmonad";
  };

  config = mkIf cfg.enable {
    # home.packages = [ inputs.kmonad.packages.${pkgs.system}.default ];
    home.file.".config/kmonad/config.kbd".source = ./kmonad/config.kbd;
  };
}
