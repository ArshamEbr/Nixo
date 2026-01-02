{ 
  config,
  lib,
  pkgs,
  ... 
}:

let
  cfg = config.services.wallpaper-manager-system;

  triggerScript = pkgs.writeShellScript "wallpaper-trigger" ''
    # Trigger update for all graphical user sessions
    for user_runtime in /run/user/*; do
      uid=$(basename "$user_runtime")
      if [[ -S "$user_runtime/wayland-0" ]] || [[ -S "$user_runtime/wayland-1" ]]; then
        ${pkgs.systemd}/bin/systemctl --user -M "$uid@" start --no-block wallpaper-manager-update.service 2>/dev/null || true
      fi
    done
  '';

  libvirtHookScript = pkgs.writeShellScript "qemu-hook" ''
    GUEST_NAME="$1"
    OPERATION="$2"

    # Trigger on VM start/stop for monitored VMs
    case "$OPERATION" in
      started|stopped|reconnect)
        ${triggerScript}
        ;;
    esac
  '';

in {
  options.services.wallpaper-manager-system = {
    enable = lib.mkEnableOption "system-level wallpaper manager triggers";
    
    enableUdevRules = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable udev rules for power supply changes";
    };

    enableLibvirtHook = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable libvirt hooks for VM state changes";
    };
  };

  config = lib.mkIf cfg.enable {
    # Udev rule for AC power changes
    services.udev.extraRules = lib.mkIf cfg.enableUdevRules ''
      # Trigger wallpaper update on AC adapter plug/unplug
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${triggerScript}"
    '';

    # Libvirt hook for VM state changes
    systemd.tmpfiles.rules = lib.mkIf cfg.enableLibvirtHook [
      "d /var/lib/libvirt/hooks 0755 root root -"
    ];

    system.activationScripts.libvirtWallpaperHook = lib.mkIf cfg.enableLibvirtHook ''
      mkdir -p /var/lib/libvirt/hooks
      ln -sf ${libvirtHookScript} /var/lib/libvirt/hooks/qemu
      chmod +x /var/lib/libvirt/hooks/qemu
    '';
  };
}