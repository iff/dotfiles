{ config, lib, pkgs, ... }:

let
  # FIXME does that work?
  install_lsp = pkgs.writeShellScriptBin "install_lsp" ''
    #!/bin/bash
    npm i -g npm typescript typescript-language-server
  '';

  # FIXME some need to run make or other commands?
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
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      plugins = with pkgs.vimPlugins;[
        (plug "phaazon" "hop.nvim" "90db1b2c61b820e230599a04fedcd2679e64bd07" "sha256-UZZlo5n1x8UfM9OP7RHfT3sFRfMpLkBLbEdcSO+SU6E=")
        (plug "tpope" "vim-fugitive" "bba8d1beb37fe933a9f182b6bdf981e01f31499a" "sha256-4X9v6SXEFaC8D2qoCTZtEx448TPAnYlFdfwAnFVnhDE=")
        (plug "lewis6991" "gitsigns.nvim" "3b6c0a6412b31b91eb26bb8f712562cf7bb1d3be" "sha256-Ny2kW4FpA5reDmvJkXaezRi2BlIaTiIZYFuTuunFJh8=")
        (plug "dkuettel" "funky-formatter.nvim" "54b04696440080363487c3ee8db8351afd4c61c4" "sha256-CS9SgD/cdyY14YOwWZDA0K7rflx5BuN/tGTLFQeaIaY=")
        (plug "dkuettel" "funky-contexts.nvim" "aa46153496278c1a318251230440228876e8baf7" "sha256-auPPCXoIukKNUKMGY4H5D8pF1Mz/HAAJIecRiiP4pIU=")
        (plug "numToStr" "Comment.nvim" "6821b3ae27a57f1f3cf8ed030e4a55d70d0c4e43" "sha256-SwN67ILsNJk0bNkcfQFiipAULaDxTfnCDHSC/+XKeLA=")
        (plug "EdenEast" "nightfox.nvim" "5e9c8ca12f0bfefd958d3729ee2182499e7a6e73" "sha256-kbQlUQgW+rt/UPZwd4CMT8tJSheodSg7AH7CHDpbh+s=")
        (plug "nvim-tree" "nvim-web-devicons" "c2c2317f356c8b7da0252f5da758f71bb60bb6b2" "sha256-WHymlANhUr/4Trxs0P/huCVRyOHTns1drfFS0hBm2GA=")
        (plug "nvim-lualine" "lualine.nvim" "e99d733e0213ceb8f548ae6551b04ae32e590c80" "sha256-mItWWRqWj9a/JaW8sccnGBijBsvvnh/b4q/S60UwYwc")
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
