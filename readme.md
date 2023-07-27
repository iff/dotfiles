# dots

Collection of dotfiles managed by [nix]/[home-manager] and NixOS configuration.

[home-manager]: https://github.com/nix-community/home-manager
[nix]: https://nixos.org/

## Setup

### Script

Get a Github API token for `gh`, then run

```
bash <(curl https://raw.githubusercontent.com/iff/dotfiles/master/sh)
```

to

- install Nix and set experimental features
- create an ssh key (one per machine)
- `gh auth login`
- clone repository and run `nix run`

### Manual

Assuming installed Nix/NixOS, eg. `curl -L https://nixos.org/nix/install | sh` and make sure that flakes are enabled:

```
echo "extra-experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Then just clone and install:

```
git clone git@github.com:iff/dotfiles.git
nix run . switch -- --flake .#$(hostname)
```

After the first activation use home-manager: `home-manager switch --flake .#$(hostname)`

## Resources

[home-manager-manual]: https://nix-community.github.io/home-manager/
[nix-manual]: https://nixos.org/manual/nix/stable/
[nixpkgs-manual]: https://nixos.org/manual/nixpkgs/stable/
[nixos-manual]: https://nixos.org/manual/nixos/stable/

## References

[nyx]: https://github.com/EdenEast/nyx
