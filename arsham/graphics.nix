{ config, pkgs, pkgs-unstable, ... }:
{
  config = {
    hardware.graphics = { # Enable OpenGL
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vpl-gpu-rt intel-media-driver ];
    };
    
    services.ollama = {
      enable = true;
      package = pkgs-unstable.ollama;
      host = "0.0.0.0";
      port = 11434;
      acceleration = "cuda";
      models = "~/models";
    };

    # Load Intel driver for Xorg and Waylandard
    environment.variables.LIBVA_DRIVER_NAME = "iHD";
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
