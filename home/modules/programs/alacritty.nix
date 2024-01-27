{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.dots.alacritty;
in
{
  options.dots.alacritty = {
    enable = mkEnableOption "enable alacritty";
    font_size = mkOption {
      description = "alacritty font size";
      type = types.number;
    };
    font_normal = mkOption {
      description = "alacritty normal font";
      type = types.str;
      default = "Ubuntu Mono Nerd Font Complete Mono";
    };
  };

  config = mkIf cfg.enable {
    # FIXME alacritty and TMUX have issues with OSX native ncurses
    # see https://github.com/NixOS/nixpkgs/issues/204144
    home.packages = [ ] ++ lib.optionals pkgs.stdenv.isDarwin [ pkgs.ncurses ];

    programs.alacritty = {
      enable = cfg.enable;
      # FIXME font can't be in basic and override here, need proper merger
      settings = { font.normal.family = cfg.font_normal; font.size = cfg.font_size; } // lib.attrsets.recursiveUpdate (import ./alacritty/basics.nix) (import ./alacritty/colors.nix);
    };
  };
}
