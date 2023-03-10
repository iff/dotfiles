{ pkgs, ... }:

let
  git-ssh-dispatch = pkgs.writeScriptBin "git-ssh-dispatch"
    ''
      #!/bin/zsh
      set -eu -o pipefail
    
      # this script roughly acts like openssh
      # at least in terms of how git uses it
    
      if [[ $1 == '-G' && $# == 2 ]]; then
          ssh $@
          exit
      fi
    
      if [[ ! $2 =~ "git-(upload|receive)-pack '(.*)'" && $# == 2 ]]; then
          echo 'unexpected form' $@ >&2
          exit 1
      fi
    
      target=$1:$match[2]
    
      case $target in
    
          (git@github.com:dkuettel/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:iff/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:werehamster/*)
              key=private
              user="Yves Ineichen iff@yvesineichen.com"
              ;;
    
          (git@github.com:ThingWorx/*)
              key=work
              user="Yves Ineichen yineichen@ptc.com"
              ;;
    
          (*)
              echo 'no match for' $target >&2
              exit 1
              ;;
    
      esac
    
      if [[ -e .git && -v user ]]; then
          if ! actual="$(git config --get user.name) $(git config --get user.email)"; then
              echo 'no git user is set instead of' $user >&2
              exit 1
          fi
          if [[ $actual != $user ]]; then
              echo 'git user is' $actual 'but expected' $user >&2
              exit 1
          fi
      fi
    
      echo $target '->' $key >&2
      ssh -i ~/.ssh/$key $@
    '';
in
{
  home.stateVersion = "22.11";

  # TODO: https://nix-community.github.io/home-manager/#sec-install-nixos-module
  # do we need to set?:
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    git-ssh-dispatch
    pkgs.direnv
    pkgs.exa
    pkgs.git
    pkgs.jq
    pkgs.nix-direnv
    pkgs.tmux
    # fonts
    pkgs.fontconfig
    (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; })
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # TODO: switch to hm config
  home.file.".gitconfig".source = ./git/gitconfig;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
}
