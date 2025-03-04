{ config, lib, pkgs, ... }:

{
  options = {
    system.build.ukiScript = lib.mkOption {
      type = lib.types.package;
      description = "Script to build the UKI.";
    };
  };

  config = {
    system.build.ukiScript = pkgs.writeScriptBin "nixo-build-uki" ''
      #!/run/current-system/sw/bin/bash

      # Get paths from NixOS configuration
      KERNEL=$(readlink -f "${config.boot.kernelPackages.kernel}/bzImage")
      INITRD=$(readlink -f "${config.system.build.initialRamdisk}/initrd")
      TOPLEVEL=$(readlink -f "${config.system.build.toplevel}")

      # Construct the kernel command line
      CMDLINE="initrd=\\EFI\\nixos\\$(basename $INITRD) init=$TOPLEVEL/init ${toString config.boot.kernelParams}"

      # Output directory
      ESP="/boot/EFI/nixos"

      # Rotate old UKIs
      mv "$ESP/nixos2.efi" "$ESP/nixos3.efi" || true
      mv "$ESP/nixos1.efi" "$ESP/nixos2.efi" || true

      # Build the new UKI
      sudo ukify build \
        --linux "$KERNEL" \
        --initrd "$INITRD" \
        --cmdline "$CMDLINE" \
        --output "$ESP/nixos1.efi"
    '';

    environment.systemPackages = [ config.system.build.ukiScript ];
  };
}