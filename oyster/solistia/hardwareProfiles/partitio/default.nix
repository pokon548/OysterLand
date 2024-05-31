{ inputs, config, cell, lib, pkgs }:
let
  inherit (inputs) nixos-hardware;
in
{
  imports = with nixos-hardware.nixosModules; [
    common-pc-ssd
    common-cpu-intel
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
    "tpm"
    "tpm_tis"
    "tpm_crb"
  ];

  services.hardware.bolt.enable = true;
  services.thermald.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Workaround: https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/766
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=generic
    options snd-hda-intel dmic_detect=0
    blacklist snd_soc_skl
  '';

  # Workaround: Lenovo seems f**ked up acpi power management. Without this config,
  #             suspend (to ram / disk) will simply reboot instead of power off. :(
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
  '';

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva
      #intel-ocl
      intel-vaapi-driver
    ];
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
