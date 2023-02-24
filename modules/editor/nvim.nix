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
in
{
  programs = {
    neovim = {
      enable = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      plugins = with pkgs.vimPlugins;[ ];
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
