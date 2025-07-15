/**
  Configures system event notifications with sound alerts for hardware, power, and network changes.
  Installs a shell script to play event-specific sounds, sets up dispatcher scripts for Wi-Fi events,
  and defines udev rules for USB and power supply actions. Enables related system services for alerts.
*/

{
  pkgs,
  user,
  ...
}:

let
  # Notification script for system events
  prophet_events = pkgs.writeShellScriptBin "notifx1" ''
    #!/run/current-system/sw/bin/bash
    declare -A sounds=(
      [usb_add]=~/nixo/resources/sfx/system/hardware_add.mp3
      [usb_remove]=~/nixo/resources/sfx/system/hardware_remove.mp3
      [startup]=~/nixo/resources/sfx/system/startup.mp3
      [wifi_connected]=~/nixo/resources/sfx/system/network_connected.mp3
      [wifi_disconnected]=~/nixo/resources/sfx/system/network_disconnected.mp3
      [charging]=~/nixo/resources/sfx/power/charging.mp3
      [discharging]=~/nixo/resources/sfx/power/discharging.mp3
      [max_pwr]=~/nixo/resources/sfx/power/performance.mp3
      [max_save]=~/nixo/resources/sfx/power/power_saving.mp3
      [conserve_on]=~/nixo/resources/sfx/power/battery_conserve_on.mp3
      [conserve_off]=~/nixo/resources/sfx/power/battery_conserve_off.mp3
      [detached]=~/nixo/resources/sfx/hardware/detached.mp3
      [reattached]=~/nixo/resources/sfx/hardware/reattached.mp3
      [vfio_on]=~/nixo/resources/sfx/hardware/detached.mp3
      [vfio_off]=~/nixo/resources/sfx/hardware/vfio_off.mp3
      [vfio_fail]=~/nixo/resources/sfx/hardware/vfio_fail.mp3
      [cpu_overload]=~/nixo/resources/sfx/system/cpu_overload.mp3
      [nix_build_failed]=~/nixo/resources/sfx/system/warning.mp3
      [nix_build_ok]=~/nixo/resources/sfx/system/build_sucess.mp3
      [nix_build_start]=~/nixo/resources/sfx/system/build_start.mp3
      [warn]=~/nixo/resources/sfx/system/warning.mp3
      [notif]=~/nixo/resources/sfx/system/notification.mp3
      [10]=~/nixo/resources/sfx/power/10.mp3
      [20]=~/nixo/resources/sfx/power/20.mp3
      [30]=~/nixo/resources/sfx/power/30.mp3
      [40]=~/nixo/resources/sfx/power/40.mp3
      [50]=~/nixo/resources/sfx/power/50.mp3
      [60]=~/nixo/resources/sfx/power/60.mp3
      [70]=~/nixo/resources/sfx/power/70.mp3
      [80]=~/nixo/resources/sfx/power/80.mp3
      [90]=~/nixo/resources/sfx/power/90.mp3
      [100]=~/nixo/resources/sfx/power/100.mp3
    )
    if [[ -n "''${sounds[$1]}" ]]; then
      paplay "''${sounds[$1]}"
    else
      echo "Unknown event: $1"
    fi
  '';
in
{
  imports = [ ./warn.nix ];

  environment.systemPackages = with pkgs; [ prophet_events ];

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "wifiSoundHook" ''
        #!/run/current-system/sw/bin/bash
        STATE_FILE="/tmp/network_state_$1"
        CURRENT_STATE="$2"
        PREVIOUS_STATE="none"
        [[ -f "$STATE_FILE" ]] && PREVIOUS_STATE=$(<"$STATE_FILE")
        if [[ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
          case "$CURRENT_STATE" in
            up)
              ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 wifi_connected
              ;;
            down)
              ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 wifi_disconnected
              ;;
          esac
          echo "$CURRENT_STATE" > "$STATE_FILE"
        fi
      '';
      type = "basic";
    }
  ];

  services = {
    battery-events.enable = true;
    overheat-alert = {
      enable = true;
      temperatureThreshold = 100;
    };
    low-ram-warning = {
      enable = false;
      ramThreshold = 1500;
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 usb_add & disown"
      ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 usb_remove & disown"
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 charging & disown"
      ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 discharging & disown"
    '';
  };
}