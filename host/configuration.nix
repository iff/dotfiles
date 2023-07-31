{ config, pkgs, ... }:

let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # nixos has to manage grub, will regularly change entries (configurations)
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      # efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
      useOSProber = true;
    };
  };


  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  nixpkgs.config.allowUnfree = true;

  # xserver config
  # services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  # services.xserver.layout = "us";
  # services.xserver.displayManager.gdm = {
  #   enable = false;
  #   wayland = true;
  # };

  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  programs.xwayland.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.nvidiaPatches = true;
  programs.hyprland.xwayland.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # gtkUsePortal = true;
  };

  # hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];

  programs.zsh.enable = true;

  users.users.iff = {
    isNormalUser = true;
    extraGroups = [ "wheel" "systemd-journal" "audio" "video" "input" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    git
    google-chrome
    jq
    lnav
    pulsemixer
    tree
    vim
    # wayland
    wl-clipboard
    wlr-randr
    wayland
    wayland-scanner
    wayland-utils
    # egl-wayland
    wayland-protocols
  ];

  # TODO not so sure that this helps?
  fonts.fontconfig = {
    antialias = true;

    # fixes antialiasing blur
    hinting = {
      enable = true;
      style = "slight"; # no difference
      autohint = true; # no difference
    };

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  # security.polkit.enable = true;
  security.pam.services.swaylock = {};

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  system.stateVersion = "23.05";
}

