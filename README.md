# dot-files

Everything after the dot.

- clone the repo
- install nix (TODO)
- `echo "extra-experimental-features = nix-commands flakes" >> ~/.config/nix/nix.config`
- `nix run . switch -- --flake .#iff.linux/darwin`
- in the future use: `home-manager switch --flake .#iff.linux/darwin`
