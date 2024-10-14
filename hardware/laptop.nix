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
    "dm-crypt"
    "dm-snapshot"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.systemd.enable = true;
  boot.initrd.services.lvm.enable = true;

  boot.initrd.luks = {
    devices."ssd" = {
      device = "/dev/disk/by-uuid/146d62b0-7a2e-4eda-bfe4-701a444e1a23";
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
    device = "/dev/nvme/root_nixos"; # TODO: use uuid
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7394-F8C8";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/eb2de450-7a9b-44bc-a366-7b6770bcb161"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
