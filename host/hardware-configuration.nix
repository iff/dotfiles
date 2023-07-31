# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0e96cc4b-43f2-4671-adce-d1db204da693";
      fsType = "ext4";
    };
  fileSystems."/boot/efi" = 
    { device = "/dev/disk/by-uuid/9F4C-752E";
      fsType = "vfat";
    };
  fileSystems."/pics" = 
    { device = "/dev/disk/by-uuid/b898a75d-5616-42a6-9e64-7ead819e21e5";
      fsType = "ext4";
    };
  # fileSystems."/mnt/ubuntu" = 
  #   { device = "/dev/disk/by-uuid/39f82f22-e8f2-4710-b67a-4d356f213280";
  #     fsType = "ext4";
  #   };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux"; # warning: the group 'nixbld' specified in 'build-users-group' does not exist;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.nvidia.powerManagement.enable = true;
}
