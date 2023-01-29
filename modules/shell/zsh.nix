{ config, pkgs, lib, ... }: {

  programs.zsh = lib.mkMerge [
    ({
      initExtra = lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^R' history-incremental-search-backward
      '';
    })
    {
      enable = true;

      shellAliases = {
        reload = ". ~/.zshrc";
        la = "exa --long --header --all --icons --git";
        ll = "exa --long --header --icons --git";
        md = "mkdir -p";
        man = "man --no-justification";
        k = "kubectl";
        v = "nvim";
      };

      initExtra = ''
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
        ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
        ZSH_HIGHLIGHT_MAXLENGTH=2000

        export TERM=xterm-256color

        # FIXME how to properly add nix path?
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      '' + builtins.readFile ../../zsh/zshrc;

      plugins = [
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "b2c910a85ed84cb7e5108e7cb3406a2e825a858f";
            sha256 = "lxwkVq9Ysvl2ZosD+riQ8dsCQIB5X4kqP+ix7XTDkKw=";
          };
        }
      ];
    }
  ];
}
