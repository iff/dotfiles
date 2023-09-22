{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.ltstatus;
in
{
  options.dots.ltstatus = {
    enable = mkEnableOption "enable ltstatus";
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.ltstatus.packages.${pkgs.system}.default ];
  };
}
