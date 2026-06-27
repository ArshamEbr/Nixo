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
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;  
      };
    };
    
    kernelParams = [
    #  "quiet"
    #  "initcall_debug=n"
    #  "systemd.show_status=0"
      "fastboot"
      "intel_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=10de:1c94"
      "vfio-pci.enable_msi=1"
      "kvmfr_static_size_mb=64"
      "i915.enable_psr=1"
    ];
    
    initrd = {
      systemd.enable = true;
    #  verbose = false;
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
      theme = "owl"; # rog_2
      themePackages = with pkgs; [
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