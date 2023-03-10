{
  description = "home manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # life on the cutting edge
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs @ { self, nixpkgs, flake-utils, neovim-nightly-overlay, home-manager, ... }: {
    # needed for bootstrapping with nix run
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;

    homeConfigurations = (
      import ./homes {
        inherit (nixpkgs) lib; # TODO necessary?
        inherit inputs nixpkgs home-manager neovim-nightly-overlay;
      }
    );
  };
}
