{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  services.openssh = {
    enable = true;
    ports = [ 3438 ];
    settings = {
      # AllowUsers = [ "xxx" ];
      X11Forwarding = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # https://nixos.wiki/wiki/Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    data-root = "/scratch/docker-sm";
  };

  # users.users.yineichen = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "systemd-journal" "audio" "video" "input" "networkmanager" "docker" ];
  #   shell = pkgs.zsh;
  #   packages = with pkgs; [
  #   ];
  # };

  # nvidia docker
  # systemd.services.containerd.path = with pkgs; [
  #   containerd
  #   nvidia-container-toolkit
  # ];
  hardware.nvidia-container-toolkit.enable = true;

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
