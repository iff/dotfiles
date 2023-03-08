{
  description = "home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # life on the cutting edge
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO darwin configuration.nix (system stuff?)
    # darwin = {
    #   url = "github:lnl7/nix-darwin/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO nvim plugins here?
    # trouble = {
    #   url = "github:folke/trouble.nvim";
    #   flake = false;
    # };

  };

  outputs = { nixpkgs, flake-utils, neovim-nightly-overlay, home-manager, ... }:
    {
      homeConfigurations = {
        "iff.linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./linux
            ./base.nix
            {
              nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
            }
          ]
          ++ (import ./modules/editor)
          ++ (import ./modules/shell);
        };

        "iff.darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules =
            [
              ./darwin
              ./base.nix
              {
                nixpkgs.overlays = [ neovim-nightly-overlay.overlay ];
              }
            ]
            ++ (import ./modules/editor)
            ++ (import ./modules/shell)
            ++ (import ./modules/programs);
        };
      };
    };
}
