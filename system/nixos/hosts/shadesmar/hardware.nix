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
        device = "nodev";
        useOSProber = true;
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
  fileSystems."/scratch" =
    {
      device = "/dev/disk/by-uuid/923aa534-f79d-43fa-8532-fc6a5f0cfd6a";
      fsType = "btrfs";
    };
  fileSystems."/data" =
    {
      device = "/dev/disk/by-uuid/dd44e584-a85b-481e-9772-339b1c6ecb7b";
      fsType = "ext4";
    };
  fileSystems."/uhome" =
    {
      device = "/dev/disk/by-uuid/7c79a22d-2996-4638-9106-08e957c1d722";
      fsType = "ext4";
      options = [ "ro" ];
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
