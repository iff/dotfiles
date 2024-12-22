{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-gui
    geeqie
    google-chrome
    spotify
    syncthing
  ];

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
  # users.users.yineichen.extraGroups = [ "docker" ];
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.daemon.settings = {
    data-root = "/scratch/docker";
  };

  users.users.yineichen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "systemd-journal" "audio" "video" "input" "networkmanager" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # nvidia docker
  systemd.services.containerd.path = with pkgs; [
    containerd
    # runc
    # iptables
    nvidia-container-toolkit
  ];

  dots = {
    profiles = {
      dwm.enable = true;
      linux.enable = true;
    };
    alacritty = {
      enable = true;
      font_size = 12.0;
      font_normal = "ZedMono Nerd Font";
    };
    osh.enable = true;
    zen.enable = true;
  };
}
