{ config, lib, pkgs, iff-dwm, ... }:

with lib;
let
  cfg = config.dots.profiles.desktop;

  wmList = [ "hyprland" "dwm" ];
in
{
  options.dots.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
    wm = mkOption {
      description = "window manager";
      type = types.enum (wmList);
      default = "hyprland";
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

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      # FIXME: move chrome to HM
      google-chrome
      pamixer
      pulsemixer
    ] ++ lib.optionals (cfg.wm == "hyprland") [
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

    hardware.opengl.enable = true;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    hardware.nvidia.powerManagement.enable = true;

    # xorg and dwm

    services.xserver = mkIf (cfg.wm == "dwm") {
      enable = true;
      layout = "us";
      videoDrivers = [ "nvidia" ];
      # no display manager (https://nixos.wiki/wiki/Using_X_without_a_Display_Manager)
      displayManager.startx.enable = true;
      # currently only for DWM
      windowManager.dwm.package = pkgs.dwm.overrideAttrs {
        src = iff-dwm;
      };
    };

    # wayland and hyprland setup below

    programs.xwayland.enable = mkIf (cfg.wm == "hyprland") true;
    programs.hyprland = mkIf (cfg.wm == "hyprland") {
      enable = true;
      nvidiaPatches = true;
      xwayland.enable = true;
    };

    xdg.portal = mkIf (cfg.wm == "hyprland") {
      enable = true;
      wlr.enable = true;
      # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # gtkUsePortal = true;
    };

    security.pam.services = mkIf (cfg.wm == "hyprland") {
      swaylock = { };
    };

  };
}
