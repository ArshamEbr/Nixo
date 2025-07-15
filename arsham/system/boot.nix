{
  pkgs,
  pkgs-stable,
  ...
}:

{
  boot = {
    extraModprobeConfig = "options snd_hda_intel model=alcplugfix";
    consoleLogLevel = 0;
    supportedFilesystems = [ "ntfs" "nfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    extraModulePackages = [
      pkgs.linuxKernel.packages.linux_xanmod_latest.kvmfr
    ];
    
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      timeout = 0;
    };
    
    kernelParams = [
      "quiet"                    # Suppress most boot messages
      "initcall_debug=n"         # Disable initcall debugging
      "systemd.show_status=0"    # Hide systemd status messages
      "fastboot"                 # Skip certain boot checks for faster boot
      "intel_iommu=on"           # Enable Intel IOMMU for device passthrough
      "iommu=pt"                 # Enable passthrough mode for IOMMU
      "vfio-pci.ids=10de:1c94"   # Bind specific PCI device to vfio-pci
      "vfio-pci.enable_msi=1"    # Enable MSI for vfio-pci devices
      "kvmfr_static_size_mb=64"  # Set static memory size for kvmfr
      "i915.enable_psr=1"        # Enable Panel Self Refresh for Intel graphics
    ];
    
    initrd = {
      systemd.enable = true;
      verbose = false;
      compressor = "zstd";
      compressorArgs = [ 
        "-T0"
      ];
      
      availableKernelModules = [
        "xhci_pci"
        "vmd"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
      
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
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

    kernelModules = [
      "i915"
      "uinput"
      "kvm-intel"
    ];
  };
}