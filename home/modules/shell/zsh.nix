{ config, inputs, pkgs, lib, ... }: {

  programs.zsh = lib.mkMerge [
    ({
      # FIXME only on work machine
      initExtraBeforeCompInit = lib.optionalString pkgs.stdenv.isLinux ''
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
        ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/efs)
        ZSH_HIGHLIGHT_MAXLENGTH=2000
      '';
    })
    {
      enable = true;

      shellAliases = {
        reload = ". ~/.zshrc";
        ls = "eza --header --git --time-style=relative --icons --no-permissions --no-user --long --mounts --sort=name";
        lr = "ls --sort=newest";
        la = "eza --long --header --all --icons --git";
        ll = "eza --header --git --time-style=long-iso --icons --group --long --mounts --sort=name";
        md = "mkdir -p";
        man = "man --no-justification";
        k = "kubectl";
        v = "nvim";
        dk = "docker kill $(docker ps -q)";
      };

      initExtraBeforeCompInit = ''
        path+="$HOME/.nix-profile/bin"
      ''
      + builtins.readFile ./zsh/config.zsh
      + builtins.readFile ./zsh/prompt.zsh
      + builtins.readFile ./zsh/completion.zsh
      + builtins.readFile ./zsh/hooks.zsh; # needs to be last

      # TODO or set to empty and control?
      completionInit = ''
        zmodload zsh/complist
        autoload -U compinit
        compinit -d ~/.zcompdump
      '';

      history = {
        size = 1000000000;
        save = 1000000000;
        ignoreDups = true;
        ignoreAllDups = false;
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
      };

      plugins = [
        {
          name = "zsh-syntax-highlighting";
          file = "zsh-syntax-highlighting.zsh";
          src = inputs.zsh-syntax-highlighting;
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
