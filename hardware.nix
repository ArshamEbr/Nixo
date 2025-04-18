# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  boot.kernelModules = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ee3239e2-5831-4e2f-ba84-07159e16f70b";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=root" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/ee3239e2-5831-4e2f-ba84-07159e16f70b";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/ee3239e2-5831-4e2f-ba84-07159e16f70b";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=home" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/71DB-2C6D";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "noatime" ];
    };

  #fileSystems."/path/to/mount/to" =
  #  { device = "/path/to/the/device";
  #    fsType = "ntfs-3g"; 
  #    options = [ "rw" "uid=theUidOfYourUser"];
  #  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/03082412-cbdd-4fe0-9dee-277408f93e2a"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
