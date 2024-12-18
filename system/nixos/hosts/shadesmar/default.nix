{ ... }:

{
  imports = [ ./hardware.nix ];

  dots = {
    modules = {
      user.home = ./home.nix;
      user.name = "yineichen";
    };
    profiles = {
      desktop = {
        enable = true;
        wm = "dwm";
      };
    };
  };
}
