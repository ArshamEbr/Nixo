{
  pkgs, 
  pkgs-stable, 
  ... 
}:

{
  boot = {
    extraModulePackages = [ pkgs-stable.linuxKernel.packages.linux_6_14.kvmfr ];
    extraModprobeConfig = "options snd_hda_intel model=alcplugfix";
    consoleLogLevel = 0;
    supportedFilesystems = [ "ntfs" "nfs" ];
  #  kernelPackages = pkgs-unstable.linuxPackages_latest; # 6.13 kernel not fixed rn in jan 21
  #  kernelPackages = pkgs-stable.linux_xanmod_latest;
    kernelPackages = pkgs-stable.linuxPackages_6_14;
    
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      grub.enable = false;
      timeout = 0;
    };
    
    kernelParams = [
      "quiet"
      "initcall_debug=n"
      "systemd.show_status=0"
      "fastboot"
      "intel_iommu=on"          
      "iommu=pt"                
      "vfio-pci.ids=10de:1c94"
      "vfio-pci.enable_msi=1"
      "kvmfr_static_size_mb=64"
      "i915.enable_psr=1"
    ];
    
    initrd = {
      verbose = false;
      compressor = "zstd";
      systemd.enable = true;
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
        "kvmfr"
      ];
    };
      
    plymouth = {
      enable = true;
      theme = "proxzima"; # rog_2
      themePackages = with pkgs-stable; [
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
