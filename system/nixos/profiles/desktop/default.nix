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
    sound.enable = true;

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
      gnome3.adwaita-icon-theme
      mako
      wl-clipboard
      wlr-randr
      wayland
      wayland-scanner
      wayland-utils
      # egl-wayland
      wayland-protocols
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

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      # todo at some point try open source kernel modules
      open = false;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };


    # xorg and dwm

    services.xserver = mkIf (cfg.wm == "dwm") {
      enable = true;
      layout = "us";
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
