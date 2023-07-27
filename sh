#!/bin/bash
set -eux -o pipefail

# bash <(curl https://raw.githubusercontent.com/iff/dotfiles/master/sh)

install_nix() {
  curl -L https://nixos.org/nix/install | sh
  mkdir -p $HOME/.config/nix/
  echo "extra-experimental-features = nix-command flakes" >> $HOME/.config/nix/nix.conf
}

which nix || install_nix

mkdir -p $HOME/.ssh
hostname=$(hostname)
[ ! -f $HOME/.ssh/${hostname} ] && ssh-keygen -t ed25519 -C "iff@yvesineichen.com" -f $HOME/.ssh/${hostname} -N ''
echo "IdentityFile $HOME/.ssh/${hostname}" >> $HOME/.ssh/config

# TODO does this persist to non-nix shell?
# https://cli.github.com/manual/gh_auth_login
# https://cli.github.com/manual/gh_repo_clone
nix-shell -p gh --command gh auth login --hostname GitHub.com
git clone git@github.com:iff/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles && nix run . switch -- --flake .#${hostname}
