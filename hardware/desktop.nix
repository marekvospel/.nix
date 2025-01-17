{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "usbhid"
    "dm-mod"
    "dm-raid"
    "raid0"
    "dm-crypt"
    "dm-snapshot"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.systemd.enable = true;
  boot.initrd.services.lvm.enable = true;

  boot.initrd.luks = {
    devices."cryptme0n1p2" = {
      device = "/dev/disk/by-uuid/81e1a45d-e581-40c9-8698-9655d7a20dd7";
      preLVM = true;
    };
    devices."cryptme1n1p1" = {
      device = "/dev/disk/by-uuid/4d0a8eed-33d3-4cd5-aae8-627214f57b9a";
      preLVM = true;
    };
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.editor = false;
    systemd-boot.consoleMode = "max";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9ed45e49-78b9-4cab-90d6-74a6da53bbe0";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E8AD-192C";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/eb2de450-7a9b-44bc-a366-7b6770bcb161"; }
  ];

  # networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
