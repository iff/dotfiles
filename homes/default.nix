{ nixpkgs, home-manager, neovim-nightly-overlay, inputs, system, ... }:

{
  "darktower" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = { inherit inputs; };
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
    extraSpecialArgs = { inherit inputs; };
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
          sessionPath = [ "$HOME/bin" ];
        };
      }
    ]
    ++ (import ../modules/editor)
    ++ (import ../modules/shell);
  };

  "urithiru" = home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.self.pkgsBySystem."aarch64-darwin";
    extraSpecialArgs = { inherit inputs; };
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
