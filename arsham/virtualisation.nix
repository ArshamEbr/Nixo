{ pkgs, config, user, ... }:
{
  config = {

  #  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    programs.virt-manager.enable = true;

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
    ];

    virtualisation = {

      waydroid.enable = true;

      docker = {
        enable = true;
        enableOnBoot = false;
        storageDriver = "btrfs";
        package = pkgs.docker_26;
        daemon.settings.data-root = "/home/docker";
        # enableNvidia = true;
      };

      libvirtd = { 
        enable = true; # do this too: sudo virsh net-start default
        onBoot = "ignore"; # Don't start any VMs automatically on boot.
        onShutdown = "shutdown"; # Stop all running VMs on shutdown.
        qemu = {
          verbatimConfig = ''
            cgroup_device_acl = [
              "/dev/null",
              "/dev/full",
              "/dev/zero",
              "/dev/random",
              "/dev/urandom",
              "/dev/ptmx",
              "/dev/kvm",
              "/dev/kvmfr0",
              "/dev/vfio/vfio",
              "/dev/fuse",
              "/dev/vhost-vsock",
              "/dev/vhost-net",
              "/dev/shm/virtiofsd.sock.pid",
              "/dev/shm/virtiofsd.sock"
            ]
          '';
        };
      };
    };
  };
}
