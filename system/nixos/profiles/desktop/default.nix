{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.dots.profiles.desktop;

  wmList = [ "dwm" "sway" ];
in
{
  options.dots.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
    wm = mkOption {
      description = "window manager";
      type = types.enum (wmList);
      default = "sway";
    };
  };

  config = mkIf cfg.enable {
    # hardware = {
    #   pulseaudio = {
    #     enable = true;
    #     support32Bit = true;
    #     package = pkgs.pulseaudioFull;
    #   };
    # };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gcr ];

    # hardware.bluetooth.enable = true;
    # services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      pamixer
      pulsemixer
    ] ++ lib.optionals (cfg.wm == "sway") [
      xdg-utils
      glib
      dracula-theme
      adwaita-icon-theme
      mako
      wl-clipboard
      wlr-randr
      wayland
      wayland-scanner
      wayland-utils
      # egl-wayland
      wayland-protocols
    ] ++ lib.optionals (cfg.wm == "dwm") [
      xorg.xinit
    ];

    # fonts.fontconfig = {
    #   antialias = true;
    #
    #   # fixes antialiasing blur
    #   hinting = {
    #     enable = true;
    #     style = "slight"; # no difference
    #     autohint = true; # no difference
    #   };
    #
    #   subpixel = {
    #     rgba = "rgb";
    #     lcdfilter = "default";
    #   };
    # };

    hardware.graphics = {
      enable = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      # todo at some point try open source kernel modules
      # but need a new gpu for that
      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # TODO also neede for sway but actually super instable at the moment
    # services.xserver.videoDrivers = [ "nvidia" ];

    # xorg and dwm

    services.xserver = mkIf (cfg.wm == "dwm") {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "nvidia" ];
      # no display manager (https://nixos.wiki/wiki/Using_X_without_a_Display_Manager)
      displayManager.startx.enable = true;
      # currently only for DWM
      windowManager.dwm.enable = true;
      windowManager.dwm.package = pkgs.dwm.overrideAttrs {
        src = builtins.getAttr "iff-dwm" inputs;
      };
    };

    programs.slock.enable = mkIf (cfg.wm == "dwm") true;

    # wayland and sway setup below

    programs.xwayland.enable = mkIf (cfg.wm == "sway") true;

    # FIXME use home-manager to use on Ubuntu?
    programs.sway = mkIf (cfg.wm == "sway") {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # FIXME only for homemananger sway
    # security.polkit = mkIf (cfg.wm == "sway") {
    #   enable = true;
    # };

    xdg.portal = mkIf (cfg.wm == "sway") {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # gtkUsePortal = true;
    };

    security.pam.services = mkIf (cfg.wm == "sway") {
      swaylock = { };
    };

  };
}
