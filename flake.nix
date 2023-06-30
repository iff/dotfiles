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

    # nvim plugins

    # TODO darwin configuration.nix (system stuff?)
    # darwin = {
    #   url = "github:lnl7/nix-darwin/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hop-nvim = {
      url = github:phaazon/hop.nvim;
      flake = false;
    };

    fugitive-nvim = {
      url = github:tpope/vim-fugitive;
      flake = false;
    };

    gitsigns-nvim = {
      url = github:lewis6991/gitsigns.nvim;
      flake = false;
    };

    funky-formatter-nvim = {
      url = github:dkuettel/funky-formatter.nvim;
      flake = false;
    };

    funky-contexts-nvim = {
      url = github:dkuettel/funky-contexts.nvim;
      flake = false;
    };

    comment-nvim = {
      url = github:numToStr/Comment.nvim;
      flake = false;
    };

    nightfox-nvim = {
      url = github:EdenEast/nightfox.nvim;
      flake = false;
    };

    web-devicons-nvim = {
      url = github:nvim-tree/nvim-web-devicons;
      flake = false;
    };

    lualine-nvim = {
      url = github:nvim-lualine/lualine.nvim;
      flake = false;
    };

    lspconfig-nvim = {
      url = github:neovim/nvim-lspconfig;
      flake = false;
    };

    cmp-lsp-nvim = {
      url = github:hrsh7th/cmp-nvim-lsp;
      flake = false;
    };
    cmp-buffer-nvim = {
      url = github:hrsh7th/cmp-buffer;
      flake = false;
    };
    cmp-path-nvim = {
      url = github:hrsh7th/cmp-path;
      flake = false;
    };
    cmp-nvim = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };
    lsp-signature-nvim = {
      url = github:ray-x/lsp_signature.nvim;
      flake = false;
    };
    luasnip-nvim = {
      url = github:L3MON4D3/LuaSnip;
      flake = false;
    };
    cmp-luasnip-nvim = {
      url = github:saadparwaiz1/cmp_luasnip;
      flake = false;
    };
    lspkind-nvim = {
      url = github:onsails/lspkind.nvim;
      flake = false;
    };

    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    telescope-nvim = {
      url = github:nvim-telescope/telescope.nvim;
      flake = false;
    };

    telescope-fzf-native-nvim = {
      url = github:nvim-telescope/telescope-fzf-native.nvim;
      flake = false;
    };

    rust-tools-nvim = {
      url = github:simrat39/rust-tools.nvim;
      flake = false;
    };

    neodev-nvim = {
      url = github:folke/neodev.nvim;
      flake = false;
    };

    # trouble = {
    #   url = "github:folke/trouble.nvim";
    #   flake = false;
    # };

  };

  outputs = inputs @ { self, nixpkgs, flake-utils, neovim-nightly-overlay, home-manager, ... }: {
    # needed for bootstrapping with nix run
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;

    # plugins =
    #   let
    #     f = xs: pkgs.lib.attrsets.filterAttrs (k: v: !builtins.elem k xs);
    #
    #     nonPluginInputNames = [
    #       "self"
    #       "nixpkgs"
    #       "flake-utils"
    #       "neovim-nightly-overlay"
    #       "home-manager"
    #     ];
    #   in
    #   builtins.attrNames (f nonPluginInputNames inputs);

    homeConfigurations = (
      import ./homes {
        # inherit (nixpkgs) lib; # TODO necessary?
        inherit nixpkgs home-manager neovim-nightly-overlay inputs;
      }
    );

    # CI build helper
    top =
      let
        home = inputs.nixpkgs.lib.genAttrs
          (builtins.attrNames inputs.self.homeConfigurations)
          (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
      in
      home;
  };
}
