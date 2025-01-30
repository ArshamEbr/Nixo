{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    boot = {
      
      extraModprobeConfig = "options snd_hda_intel model=alcplugfix";

      loader = {
        systemd-boot.enable = true; # HELL YEAH! SYSTEMd_BOOT >:)
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
     # Mandatory for dgpu passthrough
      "intel_iommu=on"          
      "iommu=pt"                
      "vfio-pci.ids=10de:1c94"
      "vfio-pci.enable_msi=1"
      ];

      initrd.kernelModules = [
      # yea also these are mandatory for dgpu passthrough 
        "vfio_pci"          
        "vfio"
        "vfio_iommu_type1"
      ];
      loader.timeout = 0;
      consoleLogLevel = 0;
      initrd.verbose = false;
      supportedFilesystems = [ "ntfs" "nfs" ];
      plymouth = {
         enable = true;
         theme = "owl";
         themePackages = with pkgs; [
           (adi1090x-plymouth-themes.override {
             selected_themes = [ "owl" ];
           })
         ];
       };

     # kernelPackages = pkgs-unstable.linuxPackages_latest; 6.13 kernel not fixed rn in jan 21
     kernelPackages = pkgs-unstable.linuxPackages_6_12;
      kernelModules = lib.mkBefore [
        "i915"
        "uinput"
        ];
    };
  };
}
