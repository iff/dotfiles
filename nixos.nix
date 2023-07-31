{ pkgs, ... }: {

  home.packages = [
    pkgs.geeqie
    # pkgs.vscode
  ];

  services.syncthing.enable = true;

  services.wlsunset = {
    enable = true;
    latitude = "47.4";
    longitude = "8.5";
    temperature = {
      day = 5700;
      night = 3200;
    };
  };

  systemd.user.services.wlsunset.Install = { WantedBy = [ "graphical.target" ]; };

}

