{
  description = "home manager flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/25c8b480b35d409848f23a0b1889eacc1b7a95ec";
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

    hypr-contrib = {
      url = "github:hyprwm/contrib";
    };

    iff-dwm = {
      url = "github:iff/dwm/nixos";
      flake = false;
    };

    ltstatus = {
      url = "github:iff/ltstatus.flake";
      flake = true;
    };

    osh = {
      url = "github:iff/one-shell-history.flake";
      flake = true;
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

    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig;
      flake = false;
    };

    nvim-cmp = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };

    cmp-lsp-nvim = {
      url = github:hrsh7th/cmp-nvim-lsp;
      flake = false;
    };

    luasnip-nvim = {
      url = github:L3MON4D3/LuaSnip;
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

    lsp-signature-nvim = {
      url = github:ray-x/lsp_signature.nvim;
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

    # hugging face code completion
    # hfcc = {
    #   url = github:huggingface/hfcc.nvim;
    #   flake = false;
    # };
  };

  nixConfig = {
    extra-substituters = [
      "https://iff-dotfiles.cachix.org"
    ];
    extra-trusted-public-keys = [
      "iff-dotfiles.cachix.org-1:9PzCJ44z3MuyvrvjkbbMWCDl5Rrf9nt3OZHq446Wn58="
    ];
    extra-experimental-features = "nix-command flakes";
  };

  outputs = { self, flake-utils, neovim-nightly-overlay, home-manager, ... } @ inputs:
    with self.lib;

    let
      forEachSystem = genAttrs [ "x86_64-linux" "aarch64-darwin" ];
      pkgsBySystem = forEachSystem (system:
        import inputs.nixpkgs {
          inherit system;

          config.allowUnfreePredicate = pkg: builtins.elem (self.lib.getName pkg)
            [ "google-chrome" "nvidia-settings" "nvidia-x11" "roam-research" "spotify" ];
        }
      );

    in
    rec {
      inherit pkgsBySystem;
      lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

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

      homeConfigurations = mapAttrs' intoHomeManager {
        darktower = { };
        blackhole = { user = "yineichen"; };
        urithiru = { system = "aarch64-darwin"; };
      };

      nixosConfigurations = mapAttrs' intoNixOs {
        nixos = { };
      };

      # CI build helper
      top =
        let
          systems = genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
          homes = genAttrs
            (builtins.attrNames inputs.self.homeConfigurations)
            (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
        in
        systems // homes;
    };
}
