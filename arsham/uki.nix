{ config, lib, pkgs, ... }:

let
  EFI_ARCH = "x64";
  UKI_BASE_NAME = "Nixo";

  ukiScript = pkgs.writeShellScriptBin "uki-build" ''
    #!/run/current-system/sw/bin/bash
    set -euo pipefail

    export PATH=${lib.makeBinPath [ pkgs.gnused pkgs.systemdUkify pkgs.coreutils ]}:$PATH

    ESP_PATH="/boot/EFI/nixos"

    INIT_PATH="$(readlink -f /nix/var/nix/profiles/system/init)"

    CMDLINE="init=$INIT_PATH ${toString config.boot.kernelParams}"

    OS_RELEASE="/etc/os-release"

    mkdir -p "$ESP_PATH"

    # Build the UKI
    UKI=$(mktemp -u)
    ${pkgs.systemdUkify}/bin/ukify build \
      --linux "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}" \
      --initrd "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" \
      --stub "${pkgs.systemd}/lib/systemd/boot/efi/linux${EFI_ARCH}.efi.stub" \
      --cmdline "$CMDLINE" \
      --os-release "@$OS_RELEASE" \
      --output "$UKI"

    # Rotate old UKIs
    echo "Rotating old UKIs..."
    if [ -e "$ESP_PATH/${UKI_BASE_NAME}3.efi" ]; then
      rm "$ESP_PATH/${UKI_BASE_NAME}3.efi"
    fi
    if [ -e "$ESP_PATH/${UKI_BASE_NAME}2.efi" ]; then
      mv "$ESP_PATH/${UKI_BASE_NAME}2.efi" "$ESP_PATH/${UKI_BASE_NAME}3.efi"
    fi
    if [ -e "$ESP_PATH/${UKI_BASE_NAME}1.efi" ]; then
      mv "$ESP_PATH/${UKI_BASE_NAME}1.efi" "$ESP_PATH/${UKI_BASE_NAME}2.efi"
    fi

    # Copy the new UKI to the ESP
    cp "$UKI" "$ESP_PATH/${UKI_BASE_NAME}1.efi"
    rm "$UKI"

    echo "UKI build complete."
  '';
in {
  system.activationScripts.uki-build = {
    text = ''
      ${ukiScript}/bin/uki-build
    '';
    deps = [ ]; 
  };
}