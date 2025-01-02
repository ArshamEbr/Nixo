{ config, lib, pkgs, pkgs-unstable, ... }:
{
  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=10de:1c94"
      #"vfio-pci.ids=8086:9a49"
      ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
       # "nvidia"
       # "nvidia_modeset"
       # "nvidia_uvm"
       # "nvidia_drm"
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
      kernelModules = [ "uinput" ];
    };
  };
}
