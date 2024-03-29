{ config, inputs, lib, pkgs, ... }:

{
  config = {
    time.timeZone = "Europe/Zurich";
    i18n.defaultLocale = "en_US.UTF-8";
    networking.networkmanager.enable = true;

    services = {
      cron.enable = true;
      openssh.enable = true;
    };

    services.tailscale.enable = true;
    virtualisation.docker.enable = true;

    # TODO move
    programs.zsh.enable = true;
    users.users.iff = {
      isNormalUser = true;
      extraGroups = [ "wheel" "systemd-journal" "audio" "video" "input" "networkmanager" "docker" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
      ];
    };

    # some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [
      curl
      git
      jq
      lnav
      pciutils
      tree
      vim
    ];

    nix = {
      settings = {
        auto-optimise-store = true;
      };

      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
