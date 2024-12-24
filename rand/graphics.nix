{ config, pkgs, pkgs-unstable, ... }:
{
  config = {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ vpl-gpu-rt ];
    };

    # Load Intel driver for Xorg and Waylandard
    environment.variables.LIBVA_DRIVER_NAME = "iHD";
    services.xserver.videoDrivers = [ "intel" "nvidia" ];
    security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${pkgs.sunshine}/bin/sunshine";
    };

    hardware.nvidia = {
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
