{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    boot = {
      loader = {
        systemd-boot.enable = true; # HELL YEAH! SYSTEMd_BOOT >:)
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
     # Mandatory for dgpu passthrough
      "intel_iommu=on"          
      "iommu=pt"                
      "vfio-pci.ids=10de:1c94"
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
         theme = "cross_hud";
         themePackages = with pkgs; [
           (adi1090x-plymouth-themes.override {
             selected_themes = [ "cross_hud" ];
           })
         ];
       };

      kernelPackages = pkgs-unstable.linuxPackages_latest;
      kernelModules = lib.mkBefore [
        "i915"
        "uinput"
        ];
    };
  };
}
