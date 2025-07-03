{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {

  #  # Override the assertion check TODO change for dual boot
  #  assertions = [
  #    { assertion = true; message = "Ignoring bootloader requirement since using EFISTUB."; }
  #  ];

    boot = {

      extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_14.kvmfr ];
      extraModprobeConfig = "options snd_hda_intel model=alcplugfix";
      consoleLogLevel = 0;
      supportedFilesystems = [ "ntfs" "nfs" ];
    #  kernelPackages = pkgs-unstable.linuxPackages_latest; # 6.13 kernel not fixed rn in jan 21
      kernelPackages = pkgs.linuxPackages_6_14;

      loader = {
        systemd-boot.enable = true; ### sigh
        timeout = 0;
        grub.enable = false;
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
        "quiet"
        "initcall_debug=n"
        "systemd.show_status=0"
        "fastboot"
        "console=tty0"
        "intel_iommu=on"          
        "iommu=pt"                
        "vfio-pci.ids=10de:1c94"
        "vfio-pci.enable_msi=1"
        "kvmfr_static_size_mb=64"
        "i915.enable_psr=1"
      ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "vmd" "ahci" "usb_storage" "sd_mod" ];
        verbose = false;
        compressor = "zstd";
        compressorArgs = [ "-T0" ];
        systemd.enable = true;
        kernelModules = [
          "vfio_pci"          
          "vfio"
          "vfio_iommu_type1"
          "kvmfr"
        ];
      };

      plymouth = {
        enable = true;
        theme = "proxzima"; # rog_2
        themePackages = with pkgs; [
          plymouth-matrix-theme
          plymouth-proxzima-theme
          adi1090x-plymouth-themes
        ];
      };

      kernelModules = lib.mkBefore [
          "i915"
          "uinput"
          "kvm-intel"
        ];
    };

  #  specialisation = {
  #    liquorix = {
  #      configuration = {
  #        boot.kernelPackages = pkgs.linuxPackages_lqx;
  #        system.nixos.tags = [ "lqx" ];
  #      };
  #    };
  #  };
  };
}
