{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = {
      # availableKernelModules = [ "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" ];
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

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/0e96cc4b-43f2-4671-adce-d1db204da693";
      fsType = "ext4";
    };
  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/9F4C-752E";
      fsType = "vfat";
    };
  fileSystems."/pics" =
    {
      device = "/dev/disk/by-uuid/b898a75d-5616-42a6-9e64-7ead819e21e5";
      fsType = "ext4";
    };

  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
