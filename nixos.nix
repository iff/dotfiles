{ pkgs, ... }: {

  home.packages = [
    pkgs.geeqie
    # pkgs.vscode
  ];

  services.syncthing.enable = true;
}

