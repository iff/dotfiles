{ lib, inputs, nixpkgs, home-manager, neovim-nightly-overlay, ... }:

{
  "darktower" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      ../linux
      ../base.nix
      ../modules/programs/git.nix
      ../modules/programs/tmux.nix
      {
        nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
        home = {
          username = "iff";
          homeDirectory = "/home/iff";
        };
      }
    ]
    ++ (import ../modules/editor)
    ++ (import ../modules/shell);
  };

  "blackhole" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      ../linux
      ../base.nix
      ../modules/programs/git.nix
      ../modules/programs/tmux.nix
      {
        nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
        home = {
          username = "yineichen";
          homeDirectory = "/home/yineichen";
        };
      }
    ]
    ++ (import ../modules/editor)
    ++ (import ../modules/shell);
  };

  "urithiru" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    modules = [
      ../darwin
      ../base.nix
      ../modules/programs/git.nix
      ../modules/programs/tmux.nix
      {
        nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
        home = {
          username = "iff";
          homeDirectory = "/Users/iff";
        };
      }
    ]
    ++ (import ../modules/editor)
    ++ (import ../modules/shell)
    ++ (import ../modules/programs);
  };
}
