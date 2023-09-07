{ ... }:

{
  imports = [ ./hardware.nix ];

  # TODO causing issues with DHCP often restarting loosing connection
  # networking.interfaces.enp0s31f6.useDHCP = true;

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
