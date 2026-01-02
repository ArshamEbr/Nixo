{ 
  pkgs,
  config,
  ... 
}:

{
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ 
        vpl-gpu-rt 
        intel-media-driver 
        intel-compute-runtime 
        intel-vaapi-driver
        libvdpau-va-gl
      ];
    };
    
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };
  
  environment.variables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
    LIBVA_DRIVER_NAME = "iHD";
  };
}