{ ... }:

{
  home.stateVersion = "23.05";
  home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" "$HOME/.cargo/bin" ];

  dots = {
    profiles = {
      linux.enable = true;
    };
    alacritty.font_size = 13.0;
  };
}
