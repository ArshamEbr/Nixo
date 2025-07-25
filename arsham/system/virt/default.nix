{ 
  pkgs, 
  user, 
  ... 
}:

{
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
      daemon.settings.data-root = "/home/docker";
    };
      
    libvirtd = { 
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
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
  environment.systemPackages = with pkgs; [
    virtiofsd
    qemu
    protonup-qt
    wine64
    wine
    winetricks
    looking-glass-client # KVM client
    
    # Game related
    heroic
    lutris
    antimicrox
  ];
}
