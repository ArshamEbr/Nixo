{ config, pkgs, pkgs-unstable, ... }:
{
  config = {
    hardware.graphics = {
      package = pkgs-unstable.mesa;
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ 
        vpl-gpu-rt 
        intel-media-driver 
        intel-compute-runtime 
        vaapiIntel
        libvdpau-va-gl
        pkgs-unstable.mesa
        ];
    };
    
    services.ollama = {
      enable = false;
      package = pkgs-unstable.ollama;
      host = "0.0.0.0";
      port = 11434;
      acceleration = "cuda";
      models = "~/models";
    };

    environment.variables = {
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
      LIBVA_DRIVER_NAME = "iHD";
      GBM_BACKEND = "gbm";

      # home vars
    #  LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    #  VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
    #  LIBVA_DRIVER_NAME = "iHD";
      # curso
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };
    
    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
    
    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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
}
