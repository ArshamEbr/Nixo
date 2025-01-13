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
    enable = false; # Set to true for using it
    package = pkgs-unstable.ollama;
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
    models = "~/models";
  };
    #error: builder for '/nix/store/yky2kz5n8wl8cmhsrac1li658y27jrvb-displaylink-600.zip.drv' failed with exit code 1;
    #last 21 log lines:
    #>pkgs-unstable.displaylink
    #> ***
    #> In order to install the DisplayLink drivers, you must first
    #> comply with DisplayLink's EULA and download the binaries and
    #> sources from here:
    #>
    #> https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu-6.0
    #>
    #> Once you have downloaded the file, please use the following
    #> commands and re-run the installation:
    #>
    #> mv $PWD/"DisplayLink USB Graphics Software for Ubuntu6.0-EXE.zip" $PWD/displaylink-600.zip
    # nix-prefetch-url file://$HOME/pkgfile
    #>
    #> Alternatively, you can use the following command to download the
    #> file directly:
    #>
    #> nix-prefetch-url --name displaylink-600.zip https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip
    #>
    #> ***
    #>

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
