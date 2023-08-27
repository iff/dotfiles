{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.interfaces.enp0s31f6.useDHCP = true;

  dots = {
    profiles = {
      desktop = {
        enable = true;
        wm = "hyprland";
      };
    };
  };
}
