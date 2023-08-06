{ pkgs, inputs, lib, ... }:

with builtins;

let
  # FIXME does that work?
  install_lsp = pkgs.writeShellScriptBin "install_lsp" ''
    #!/bin/bash
    npm i -g npm typescript typescript-language-server
  '';

  isort_and_black = pkgs.writeScriptBin "isort_and_black"
    ''
      #!/bin/zsh
      set -eu -o pipefail

      # run isort and black from:
      # 1) $vim_project_folder venv, if any
      # 2) from local folder venv, if any
      # 3) else, from global installation

      if [[ -v vim_project_folder && -f $vim_project_folder/.venv/bin/isort ]]; then
          isort=$vim_project_folder/.venv/bin/isort
      elif [[ -f ./.venv/bin/isort ]]; then
          isort=./.venv/bin/isort
      else
          isort=isort
      fi

      if [[ -v vim_project_folder && -f $vim_project_folder/.venv/bin/black ]]; then
          black=$vim_project_folder/.venv/bin/black
      elif [[ -f ./.venv/bin/black ]]; then
          black=./.venv/bin/black
      else
          black=black
      fi

      $isort --profile=black --combine-as - | $black --quiet --target-version=py310 -
    '';

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    c
    javascript
    json
    cpp
    go
    python
    typescript
    rust
    bash
    html
    haskell
    regex
    css
    toml
    nix
    clojure
    latex
    lua
    make
    markdown
    vim
    yaml
    glsl
    dockerfile
    graphql
    bibtex
    cmake
  ]);

  plug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = name;
    version = "master";
    src = builtins.getAttr name inputs;
    buildPhase = ''
      ${if name == "telescope-fzf-native-nvim" then "make" else ""}
    '';
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
        (plug "hop-nvim")
        (plug "fugitive-nvim")
        (plug "gitsigns-nvim")
        (plug "funky-formatter-nvim")
        (plug "funky-contexts-nvim")
        (plug "comment-nvim")

        # theme
        (plug "nightfox-nvim")
        (plug "web-devicons-nvim")
        (plug "lualine-nvim")

        # lsp
        (plug "lspconfig-nvim")
        (plug "cmp-lsp-nvim")
        (plug "cmp-buffer-nvim")
        (plug "cmp-path-nvim")
        (plug "cmp-nvim")
        (plug "lsp-signature-nvim")
        (plug "luasnip-nvim")
        (plug "cmp-luasnip-nvim")
        (plug "lspkind-nvim")

        # telescope
        (plug "plenary-nvim")
        (plug "telescope-nvim")
        (plug "telescope-fzf-native-nvim")

        # potentially interesting plugins for the future
        # FIXME outdated nvim-lua/lsp_extensions.nvim
        # switch to https://github.com/simrat39/rust-tools.nvim for inline hints and rust
        # (see: https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/)
        # could be interesting to show lsp info in status: https://github.com/nvim-lua/lsp-status.nvim
        (plug "rust-tools-nvim")

        (plug "neodev-nvim")

        # hugging face code completion
        # (plug "hfcc")

        # letting Nix manage treesitter: https://nixos.wiki/wiki/Treesitter
        treesitter
      ];
    };
  };

  home = {
    packages = with pkgs; [
      isort_and_black
      install_lsp
      clang-tools
      pyright
      rnix-lsp
      rust-analyzer
      sumneko-lua-language-server
      yaml-language-server
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
