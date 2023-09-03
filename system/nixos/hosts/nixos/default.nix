{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.interfaces.enp0s31f6.useDHCP = true;

  dots = {
    modules = {
      user.home = ./home.nix;
      user.name = "iff";
    };
    profiles = {
      desktop = {
        enable = true;
        wm = "dwm";
      };
    };
  };
}
