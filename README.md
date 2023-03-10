# dot-files

Everything after the dot.

- clone the repo
- install nix (TODO)
- `echo "extra-experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
- `nix run . switch -- --flake .#$(hostname)`
- in the future use: `home-manager switch --flake .#$(hostname)`
