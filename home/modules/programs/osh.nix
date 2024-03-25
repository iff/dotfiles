{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.osh;
in
{
  options.dots.osh = {
    enable = mkEnableOption "enable osh-oxy";
  };

  config = mkIf cfg.enable
    {
      home.packages = [ inputs.osh-oxy.packages.${pkgs.system}.default ];

      programs.zsh.initExtraBeforeCompInit = (
        if pkgs.stdenv.isDarwin then ''
          function __osh_ts {
              date '+%s'
          }
        '' else ''
          function __osh_ts {
              date '+%s.%N'
          }
        ''
      );

      # ensure we are late in zshrc
      programs.zsh.initExtra = mkOrder 1000 ''
        function __osh {
            osh-oxy $@
        }

        autoload -U add-zsh-hook

        __osh_session_id=$(uuidgen)
        __osh_session_start=$(__osh_ts)

        function __osh_before {
            local command=''${1[0,-2]}
            if [[ $command != "" ]]; then
                __osh_current_command=(
                    --starttime $(__osh_ts)
                    --command $command
                    --folder "$(pwd)"
                )
            fi
        }
        function __osh_after {
            local exit_code=$?
            if [[ -v __osh_current_command ]]; then
            __osh_current_command+=(
                    --endtime $(__osh_ts)
                    --exit-code $exit_code
                    --machine "$(hostname)"
                    --session $__osh_session_id
                )
                __osh append-event $__osh_current_command &!
                unset __osh_current_command
            fi
            unset __osh_prefix_timestamp
            unset __osh_prefix
        }
        add-zsh-hook zshaddhistory __osh_before
        add-zsh-hook precmd __osh_after


        function __osh_search {
            BUFFER=$(__osh search --query=$BUFFER --session-id=$__osh_session_id --session-start=$__osh_session_start)
            CURSOR=$#BUFFER
            zle reset-prompt
        }
        zle -N __osh_search
        bindkey '^r' __osh_search
        bindkey -M vicmd '^r' __osh_search
        bindkey -M viins '^r' __osh_search
      '';
    };
}
