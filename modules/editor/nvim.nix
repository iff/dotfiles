{ config, lib, pkgs, ... }:

let
  # FIXME does that work?
  install_lsp = pkgs.writeShellScriptBin "install_lsp" ''
    #!/bin/bash
    npm i -g npm typescript typescript-language-server
  '';
  # FIXME: need to install Plug, maybe migrate away?
  # sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  # https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  pluginGit = owner: repo: rev: sha256: pkgs.vimUtils.buildVimPluginFrom2Nix {
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
        (pluginGit "phaazon" "hop.nvim" "90db1b2c61b820e230599a04fedcd2679e64bd07" "sha256-UZZlo5n1x8UfM9OP7RHfT3sFRfMpLkBLbEdcSO+SU6E=")
        (pluginGit "tpope" "vim-fugitive" "bba8d1beb37fe933a9f182b6bdf981e01f31499a" "sha256-4X9v6SXEFaC8D2qoCTZtEx448TPAnYlFdfwAnFVnhDE=")
        (pluginGit "lewis6991" "gitsigns.nvim" "3b6c0a6412b31b91eb26bb8f712562cf7bb1d3be" "sha256-Ny2kW4FpA5reDmvJkXaezRi2BlIaTiIZYFuTuunFJh8=")
        (pluginGit "dkuettel" "funky-formatter.nvim" "54b04696440080363487c3ee8db8351afd4c61c4" "sha256-CS9SgD/cdyY14YOwWZDA0K7rflx5BuN/tGTLFQeaIaY=")
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
