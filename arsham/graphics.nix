{ config, pkgs, pkgs-unstable, ... }:
{
  config = {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vpl-gpu-rt ];
    };
    
    services.ollama = {
    enable = true; # Set it to true for using it
    package = pkgs-unstable.ollama;
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
    models = "~/models";
  };
  /*
     *HERE* are the Steps to manually downloading a package and pass it to the 
     nix packages storage :
     Once you have downloaded the file, please use the following
     commands and re-run the nixos-rebuild:
    
     mv $HOME/Desierd-PKG-Location $PWD/Package-name-in-nix
    
     nix-prefetch-url file://$HOME/pkgfile
    
     Alternatively, you can use the following command to download the
     file directly:
    
     nix-prefetch-url --name pkg-name https://the-link-of-the-file-to-download
  */

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

   # hardware.nvidia-container-toolkit.enable = true;

   # hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

    virtualisation = {
      docker = {
        enable = true;
        package = pkgs.docker_26;
       # enableNvidia = true;
      };
   # };
   # virtualisation.containerd = {
   #   enable = true;
   #   settings =
   #     let
   #       fullCNIPlugins = pkgs.buildEnv {
   #         name = "full-cni";
   #         paths = with pkgs;[
   #           cni-plugins
   #           cni-plugin-flannel
   #         ];
   #       };
   #     in {
   #       plugins."io.containerd.grpc.v1.cri".containerd = {
   #         default_runtime_name = "nvidia";
   #         runtimes.runc = {
   #           runtime_type = "io.containerd.runc.v2";
   #         };
   #         runtimes.nvidia = {
   #           priviledged_without_host_devices = false;
   #           runtime_type = "io.containerd.runc.v2";
   #           options = {
   #             BinaryName = "/run/current-system/sw/bin/nvidia-container-runtime";
   #           };
   #         };
   #       };
   #       plugins."io.containerd.grpc.v1.cri" = {
   #         enable_cdi = true;
   #         cdi_spec_dirs = [ "/var/run/cdi" ];
   #       };
   #   };
    };
  };
}
