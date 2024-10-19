{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules = [ "dm-snapshot" ];
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot.enable = true;
    };

  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/346d26c9-5545-4606-bbc8-17a7a620369f"; }];


  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
    };
  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
