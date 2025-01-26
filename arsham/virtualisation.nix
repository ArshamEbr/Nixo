{ pkgs, config, ... }:
{
 #   imports = [
 #   ./kvmfr-package.nix
 #   ./kvmfr-options.nix
 # ];
  config = {
   # # Enable VMWare Tools.
   # virtualisation.docker = {
   #   enable = true;
   #   enableOnBoot = false;
   #   storageDriver = "btrfs";
   #   daemon.settings.data-root = "/home/docker";
   # };
    #systemd.services = {
    #  gpu-switch = {
    #    enable = true;
    #    description = "Enabling this service disabled the nvidia gpu from host system, Disabling re-enables it.";
    #    serviceConfig = {
    #      User = "root";
    #      Type = "oneshot";
    #      RemainAfterExit = "yes";
    #      #ExecStart = [
    #      #  "${pkgs.libvirt}/bin/virsh nodedev-detach drm_card2"
    #      #  
    #      #];
    #      ExecStart = [
    #      "${pkgs.bash}/run/current-system/sw/bin/bash" "-c" ''
    #       sudo rmmod nvidia_modeset nvidia_uvm nvidia
    #       sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
    #       sudo virsh nodedev-detach pci_0000_01_00_0
    #      ''
    #    ];
    #      ExecStop = [
    #       # "${pkgs.libvirt}/bin/virsh nodedev-reattach drm_card2"
    #      ];
    #    };
    #    #wantedBy = [ "docker-windows.service" ];  # TODO: ???? Does this worK? # dunno LOL
    #  };
    #};

   # virtualisation.oci-containers = {
   #   backend = "docker";
   #   containers = {
   #     windows = {
   #       hostname = "winvm";
   #       autoStart = true;
   #       image = "ghcr.io/dockur/windows:latest";
   #       volumes = [
   #         "/mnt/shared:/shared"
   #         "/home/docker/windows/data:/storage"
   #         "/etc/nixos/scripts:/oem"
   #         "/home/arsham/win11.iso:/custom.iso"
#  #          "/home/arsham/virtio.iso:/virtio.iso"
   #       ];
   #       ports = [
   #         "8006:8006"
   #         "3389:3389"
   #       ];
   #       environment = {
   #         VERSION = "win11e";
   #         USERNAME = "Arsham";
   #         PASSWORD = "1";
   #         DISK_SIZE = "32G";
   #         RAM_SIZE = "4G";
   #         CPU_CORES = "4";
 # #          MANUAL = "Y";
   #       };
   #       extraOptions = [
   #         "--cap-add=NET_ADMIN"
   #         "--device=/dev/kvm"
   #         "--device=/dev/dri/card2"
   #         "--device=/dev/vfio/vfio"
   #        # "--device=nvidia.com/gpu=all"
   #         "--stop-timeout=120"
   #       ];
   #     };
   #   };
   # };
    # Enable QEMU
    virtualisation = {
      libvirtd = { 
       enable = true; # do this too: sudo virsh net-start default
       onBoot = "ignore"; # Don't start any VMs automatically on boot.
       onShutdown = "shutdown"; # Stop all running VMs on shutdown.
      };
    };

    programs.virt-manager.enable = true;

    systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 arsham qemu-libvirtd -"
  ];

    #virtualisation.looking-glass = {
    #  enable = true;
    #  kvmfr = {
    #    enable = true;
    #    size = 64;
    #  };
    #};
  # systemd.services.libvirtd = {
  #  # scripts use binaries from these packages
  #  # NOTE: All these hooks are run with root privileges... Be careful!
  #  path =
  #    let
  #      env = pkgs.buildEnv {
  #        name = "qemu-hook-env";
  #        paths = with pkgs; [
  #          libvirt
  #          procps
  #          utillinux
  #          doas
  #          config.boot.kernelPackages.cpupower
  #          zfs
  #          ripgrep
  #          killall
  #        ];
  #      };
  #    in
  #    [ env ];
#
  #  preStart = ''
  #    mkdir -p /var/lib/libvirt/hooks
  #    mkdir -p /var/lib/libvirt/hooks/qemu.d/Win11/prepare/begin
  #    mkdir -p /var/lib/libvirt/hooks/qemu.d/Win11/release/end
  #    mkdir -p /var/lib/libvirt/hooks/qemu.d/Win11/started/begin
#
  #    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  #    ln -sf ${./start.sh} /var/lib/libvirt/hooks/qemu.d/Win11/prepare/begin/start.sh
  #    ln -sf ${./revert.sh} /var/lib/libvirt/hooks/qemu.d/Win11/release/end/revert.sh
  #  '';
  #};
 };
}
