{ config, lib, pkgs, ... }:

let
  # FIXME does that work?
  install_lsp = pkgs.writeShellScriptBin "install_lsp" ''
    #!/bin/bash
    npm i -g npm typescript typescript-language-server
  '';

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [ c javascript json cpp go python typescript rust bash html haskell regex css toml nix clojure latex lua make markdown vim yaml glsl dockerfile graphql bibtex cmake ]);

  # TODO: maybe combine with plug?
  plugm = owner: repo: rev: sha256: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
    buildPhase = ''                   
      make
    '';
  };

  # see: https://nixos.wiki/wiki/Vim#Using_flake
  plug = owner: repo: rev: sha256: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
  };
in
{
  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      plugins = with pkgs.vimPlugins; [
        (plug "phaazon" "hop.nvim" "90db1b2c61b820e230599a04fedcd2679e64bd07" "sha256-UZZlo5n1x8UfM9OP7RHfT3sFRfMpLkBLbEdcSO+SU6E=")
        (plug "tpope" "vim-fugitive" "bba8d1beb37fe933a9f182b6bdf981e01f31499a" "sha256-4X9v6SXEFaC8D2qoCTZtEx448TPAnYlFdfwAnFVnhDE=")
        (plug "lewis6991" "gitsigns.nvim" "3b6c0a6412b31b91eb26bb8f712562cf7bb1d3be" "sha256-Ny2kW4FpA5reDmvJkXaezRi2BlIaTiIZYFuTuunFJh8=")
        (plug "dkuettel" "funky-formatter.nvim" "54b04696440080363487c3ee8db8351afd4c61c4" "sha256-CS9SgD/cdyY14YOwWZDA0K7rflx5BuN/tGTLFQeaIaY=")
        (plug "dkuettel" "funky-contexts.nvim" "aa46153496278c1a318251230440228876e8baf7" "sha256-auPPCXoIukKNUKMGY4H5D8pF1Mz/HAAJIecRiiP4pIU=")
        (plug "numToStr" "Comment.nvim" "6821b3ae27a57f1f3cf8ed030e4a55d70d0c4e43" "sha256-SwN67ILsNJk0bNkcfQFiipAULaDxTfnCDHSC/+XKeLA=")

        # theme
        (plug "EdenEast" "nightfox.nvim" "5e9c8ca12f0bfefd958d3729ee2182499e7a6e73" "sha256-kbQlUQgW+rt/UPZwd4CMT8tJSheodSg7AH7CHDpbh+s=")
        (plug "nvim-tree" "nvim-web-devicons" "c2c2317f356c8b7da0252f5da758f71bb60bb6b2" "sha256-WHymlANhUr/4Trxs0P/huCVRyOHTns1drfFS0hBm2GA=")
        (plug "nvim-lualine" "lualine.nvim" "e99d733e0213ceb8f548ae6551b04ae32e590c80" "sha256-mItWWRqWj9a/JaW8sccnGBijBsvvnh/b4q/S60UwYwc")

        # lsp
        (plug "neovim" "nvim-lspconfig" "56f4c8cdcdffca8521d3415cba7894d2f9f11dfe" "sha256-lWTUx9SXcp9YADeFiGgWV+jMxrL7hEPc/jjMxYyzEFs=")
        (plug "hrsh7th" "cmp-nvim-lsp" "0e6b2ed705ddcff9738ec4ea838141654f12eeef" "sha256-DxpcPTBlvVP88PDoTheLV2fC76EXDqS2UpM5mAfj/D4=")
        (plug "hrsh7th" "cmp-buffer" "3022dbc9166796b644a841a02de8dd1cc1d311fa" "sha256-dG4U7MtnXThoa/PD+qFtCt76MQ14V1wX8GMYcvxEnbM=")
        (plug "hrsh7th" "cmp-path" "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" "sha256-G/I2SH4Uidr25/4fjrtcK3VfxWwD9MSN+ODcB6zjvVo=")
        (plug "hrsh7th" "nvim-cmp" "feed47fd1da7a1bad2c7dca456ea19c8a5a9823a" "sha256-rAFEmCXbPoHo1nZ6YHGdKcbGCpKXgQeZ0aa7InmZo2c=")
        (plug "ray-x" "lsp_signature.nvim" "6f6252f63b0baf0f2224c4caea33819a27f3f550" "sha256-g5bAumjFvA0MBPNKWqOxk5OsaR4KEe5CEsiNN5YbIQU=")
        (plug "L3MON4D3" "LuaSnip" "9b5be5e9b460fad7134991d3fd0434466959db08" "sha256-RyC2yJPAbkUVOCGh0M2N0xyjapQPkedESiVpWA1NcQ4=")
        (plug "saadparwaiz1" "cmp_luasnip" "18095520391186d634a0045dacaa346291096566" "sha256-Z5SPy3j2oHFxJ7bK8DP8Q/oRyLEMlnWyIfDaQcNVIS0=")
        (plug "onsails" "lspkind.nvim" "c68b3a003483cf382428a43035079f78474cd11e" "sha256-WwUQ+O2rIfD4yl0GFx70GsZc9nnhS7b2KWfNdaXCLmM=")

        # telescope
        (plug "nvim-lua" "plenary.nvim" "253d34830709d690f013daf2853a9d21ad7accab" "sha256-z5JHuQcF1EvySnRBywl6EOrp8aRO0nd2dnkXJg2ge58=")
        (plug "nvim-telescope" "telescope.nvim" "a3f17d3baf70df58b9d3544ea30abe52a7a832c2" "sha256-QmyVJ/LZFtb/qqD5Q5fHsqAGgqaOT9XkVoLyOcqM14w=")
        (plugm "nvim-telescope" "telescope-fzf-native.nvim" "580b6c48651cabb63455e97d7e131ed557b8c7e2" "sha256-psIJkVRHSiyuB1oX3PM4VB6ol3Ag0aYyQN/rJA6xTfo=")

        # letting Nix manage treesitter: https://nixos.wiki/wiki/Treesitter
        treesitter

        # potentially interesting plugins for the future
        # FIXME outdated nvim-lua/lsp_extensions.nvim
        # switch to https://github.com/simrat39/rust-tools.nvim for inline hints and rust
        # (see: https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)
        # could be interesting to show lsp info in status: https://github.com/nvim-lua/lsp-status.nvim
      ];
    };
  };
  home = {
    packages = with pkgs; [
      install_lsp
      clang-tools
      pyright
      rnix-lsp
      rust-analyzer
      sumneko-lua-language-server
      # formatters
      black
      nixpkgs-fmt
      nodePackages.prettier
      rustfmt
      stylua
    ];
  };

  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  home.file.".config/nvim/lua".source = ./nvim/lua;
}
