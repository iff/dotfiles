{ config, pkgs, lib, ... }: {

  programs.alacritty = lib.mkMerge [
    ({
      settings = lib.optionalAttrs pkgs.stdenv.isDarwin {
        font.size = 16.0;
      };
    })
    ({
      settings = lib.optionalAttrs pkgs.stdenv.isLinux {
        font.size = 13.0;
      };
    })
    {
      enable = true;

      settings = lib.attrsets.recursiveUpdate (import ./alacritty/basics.nix) (import ./alacritty/colors.nix);
    }
  ];
}
