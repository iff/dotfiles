{ ... }:

{
  home.stateVersion = "24.05";
  home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" ];

  dots = {
    profiles = {
      linux.enable = true;
    };
    alacritty.font_size = 13.0;
    osh.enable = true;
  };
}
