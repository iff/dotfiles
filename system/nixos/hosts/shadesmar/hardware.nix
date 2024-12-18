{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
      kernelModules = [ "dm-snapshot" ];
    };

    # loader = {
    #   efi = {
    #     canTouchEfiVariables = true;
    #     efiSysMountPoint = "/boot/efi";
    #   };
    #   systemd-boot.enable = true;
    # };

    # for now use GRUB to dual boot with ubuntu
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        # efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
        device = "nodev";
      };
    };

  };

  swapDevices = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/38a43ffb-f216-46b6-a3ef-7619d65c215a";
      fsType = "btrfs";
    };
  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/54EC-62DC";
      fsType = "vfat";
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
