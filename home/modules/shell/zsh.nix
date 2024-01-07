{ config, pkgs, lib, ... }: {

  # programs.starship.enable = true;
  # home.file.".config/starship.toml".source = ./zsh/starship.toml;

  programs.zsh = lib.mkMerge [
    ({
      initExtra = lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^R' history-incremental-search-backward
      '';
    })
    ({
      # FIXME only on work machine
      initExtra = lib.optionalString pkgs.stdenv.isLinux ''
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
        ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
        ZSH_HIGHLIGHT_MAXLENGTH=2000
      '';
    })
    {
      enable = true;

      shellAliases = {
        reload = ". ~/.zshrc";
        la = "eza --long --header --all --icons --git";
        ll = "eza --long --header --icons --git";
        md = "mkdir -p";
        man = "man --no-justification";
        k = "kubectl";
        v = "nvim";
        dk = "docker kill $(docker ps -q)";
      };

      initExtra = ''
        eval "$(direnv hook zsh)"
        # eval "$(starship init zsh)"
        path+="$HOME/.nix-profile/bin"
      ''
      + builtins.readFile ./zsh/config.zsh
      + builtins.readFile ./zsh/prompt.zsh
      + builtins.readFile ./zsh/completion.zsh;

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
        # nix run uses $SHELL
        # {
        #   name = "zsh-nix-shell";
        #   file = "nix-shell.plugin.zsh";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "chisui";
        #     repo = "zsh-nix-shell";
        #     rev = "v0.5.0";
        #     sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        #   };
        # }
      ];
    }
  ];
}
