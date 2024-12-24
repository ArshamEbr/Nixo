{ pkgs, ... }:
{
  config = {
    # Enable VMWare Tools.
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      storageDriver = "btrfs";
      daemon.settings.data-root = "/home/docker";
    };
   # systemd.services = {
   #   gpu-switch = {
   #     enable = true;
   #     description = "Enabling this service disabled the nvidia gpu from host system, Disabling re-enables it.";
   #     serviceConfig = {
   #       User = "root";
   #       Type = "oneshot";
   #       RemainAfterExit = "yes";
   #       #ExecStart = [
   #       #  "${pkgs.libvirt}/bin/virsh nodedev-detach drm_card2"
   #       #  
   #       #];
   #       ExecStart = [
   #       "${pkgs.bash}/bin/bash" "-c" ''
   #         systemctl stop display-manager.service
   #         rmmod -f nvidia_drm
   #         rmmod -f nvidia_uvm
   #         rmmod -f nvidia_modeset
   #         rmmod -f nvidia
   #         virsh nodedev-detach drm_card2
   #         modprobe vfio-pci
   #         systemctl start display-manager.service
   #       ''
   #     ];
   #       ExecStop = [
   #         "${pkgs.libvirt}/bin/virsh nodedev-reattach drm_card2"
   #       ];
   #     };
   #     wantedBy = [ "docker-windows.service" ];  # TODO: ???? Does this worK?
   #   };
   # };

    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        windows = {
          hostname = "winvm";
          autoStart = true;
          image = "ghcr.io/dockur/windows:latest";
          volumes = [
            "/mnt/shared:/shared"
            "/home/docker/windows/data:/storage"
            "/etc/nixos/scripts:/oem"
            "/home/arsham/win11.iso:/custom.iso"
#            "/home/arsham/virtio.iso:/virtio.iso"
          ];
          ports = [
            "8006:8006"
            "3389:3389"
          ];
          environment = {
            VERSION = "win11e";
            USERNAME = "Arsham";
            PASSWORD = "1";
            DISK_SIZE = "32G";
            RAM_SIZE = "4G";
            CPU_CORES = "4";
 #           MANUAL = "Y";
          };
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--device=/dev/kvm"
            "--device=/dev/dri/card2"
            "--stop-timeout=120"
          ];
        };
      };
    };
    # Enable QEMU.
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
