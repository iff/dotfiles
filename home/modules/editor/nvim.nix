{ pkgs, inputs, lib, ... }:

with builtins;

let
  pyformat = pkgs.writeScriptBin "pyformat"
    ''
      #!/usr/bin/env zsh
      set -eu -o pipefail

      if [[ -f ./.venv/bin/ruff ]]; then
          ./.venv/bin/ruff check --fix-only --select 'I' -s - | ./.venv/bin/ruff format -s -
          exit $?
      fi

      ruff check --fix-only --select 'I' -s - | ruff format -s -
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

  plug = name: pkgs.vimUtils.buildVimPlugin {
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
      package = pkgs.neovim;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = [
      ];
      plugins = with pkgs.vimPlugins; [
        (plug "hop-nvim")
        (plug "fugitive-nvim")
        (plug "gitsigns-nvim")
        (plug "lsp-indicator-nvim")
        (plug "funky-formatter-nvim")
        (plug "funky-contexts-nvim")
        (plug "comment-nvim")

        # theme
        (plug "nightfox-nvim")
        (plug "web-devicons-nvim")
        (plug "lualine-nvim")

        # lsp (minimal)
        (plug "nvim-lspconfig")
        (plug "nvim-cmp")
        (plug "cmp-lsp-nvim")
        (plug "luasnip-nvim")

        # lsp (ext completion)
        (plug "cmp-buffer-nvim")
        (plug "cmp-path-nvim")
        (plug "cmp-luasnip-nvim")
        (plug "lspkind-nvim")

        # telescope
        (plug "plenary-nvim")
        (plug "telescope-nvim")
        (plug "telescope-fzf-native-nvim")
        (plug "telescope-hop-nvim")
        (plug "telescope-ui-select-nvim")

        (plug "rustacean-nvim")

        (plug "neodev-nvim")
        (plug "kmonad-vim")
        (plug "resty-vim")

        # interesting navigation and term/tmux commands: https://github.com/ThePrimeagen/harpoon/tree/harpoon2

        # hugging face code completion
        # (plug "hfcc")

        # letting Nix manage treesitter: https://nixos.wiki/wiki/Treesitter
        treesitter
      ];
    };
  };

  home = {
    packages = with pkgs; [
      basedpyright
      pyformat
      clang-tools
      pyright
      sumneko-lua-language-server
      yaml-language-server
      # formatters
      black
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      stylua
      taplo
    ];
  };

  xdg.configFile."nvim".source = ./nvim;
}
