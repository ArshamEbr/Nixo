{ config, lib, pkgs, ... }:

let
  cfg = config.services.wallpaper-manager-system;
  
  # Define the environment variables needed for Wayland access
  waylandEnv = "WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000";
in {
  options.services.wallpaper-manager-system = {
    enable = lib.mkEnableOption "system-level wallpaper manager hooks";

    username = lib.mkOption {
      type = lib.types.str;
      description = "Username to run wallpaper-manager as";
    };

    vmName = lib.mkOption {
      type = lib.types.str;
      default = "win10";
    };

    wallpaperManagerPackage = lib.mkOption {
      type = lib.types.package;
      description = "The wallpaper-manager package from home-manager";
    };

    enableNotifications = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = let
      wallpaperCmd = "${lib.getExe cfg.wallpaperManagerPackage}";
      runAsUser = cmd: "${pkgs.systemd}/bin/machinectl shell ${cfg.username}@ ${pkgs.bash}/bin/bash -c '${waylandEnv} ${cmd}'";
    in ''
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${runAsUser "${wallpaperCmd} power charging"}"
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${runAsUser "${wallpaperCmd} power discharging"}"
    '' + lib.optionalString cfg.enableNotifications ''
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${runAsUser "notifx1 charging"}"
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${runAsUser "notifx1 discharging"}"
    '';

    virtualisation.libvirtd.hooks.qemu."wallpaper-hook" = pkgs.writeShellScript "wallpaper-qemu-hook" ''
      GUEST_NAME="$1"
      OPERATION="$2"

      [[ "$GUEST_NAME" != "${cfg.vmName}" ]] && exit 0

      run_as_user() {
        ${pkgs.systemd}/bin/machinectl shell ${cfg.username}@ ${pkgs.bash}/bin/bash -c "${waylandEnv} $1" &
      }

      case "$OPERATION" in
        started)
          run_as_user "${lib.getExe cfg.wallpaperManagerPackage} vm started"
          ;;
        stopped|release)
          run_as_user "${lib.getExe cfg.wallpaperManagerPackage} vm stopped"
          ;;
      esac

      exit 0
    '';
  };
}