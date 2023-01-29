{ pkgs, ... }: {
  # targets.genericLinux.enable = true;
  home.username = "iff";
  home.homeDirectory = "/home/iff";

  home.packages = [
    pkgs.redshift
  ];

  home.file.".config/redshift.conf".source = ../redshift/redshift.conf;
}
