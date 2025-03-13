{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {

    # Override the assertion check
    assertions = [
      { assertion = true; message = "Ignoring bootloader requirement since using EFISTUB."; }
    ];

    boot = {

      extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_12.kvmfr ];
      extraModprobeConfig = "options snd_hda_intel model=alcplugfix";
      consoleLogLevel = 0;
      supportedFilesystems = [ "ntfs" "nfs" ];
      # kernelPackages = pkgs-unstable.linuxPackages_latest; 6.13 kernel not fixed rn in jan 21
      kernelPackages = pkgs-unstable.linuxPackages_6_12;

      loader = {
        systemd-boot.enable = false;
        grub.enable = false;
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
        "fastboot"
        "intel_iommu=on"          
        "iommu=pt"                
        "vfio-pci.ids=10de:1c94"
        "vfio-pci.enable_msi=1"
        "kvmfr.static_size_mb=64"
      ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "vmd" "ahci" "usb_storage" "sd_mod" ];
        verbose = false;
        compressor = "zstd";
        compressorArgs = [ "-T0" ];
        systemd.enable = true;
        kernelModules = [
          # yea also these are mandatory for dgpu passthrough 
          "vfio_pci"          
          "vfio"
          "vfio_iommu_type1"
          "kvmfr"
        ];
      };

      plymouth = {
        enable = true;
        theme = "owl";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
             selected_themes = [ "owl" ];
          })
        ];
      };

      kernelModules = lib.mkBefore [
          "i915"
          "uinput"
          "kvm-intel"
        ];
    };
  };
}
