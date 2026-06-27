{
  pkgs,
  user,
  ...
}:

let
  # Notification script for system events
  prophet_events = pkgs.writeShellScriptBin "notifx1" ''
    #!/usr/bin/env bash
    
    declare -A sounds=(
      # --- System Events ---
      [usb_add]="$HOME/nixo/resources/sfx/system/hardware_add.mp3"
      [usb_remove]="$HOME/nixo/resources/sfx/system/hardware_remove.mp3"
      [startup]="$HOME/nixo/resources/sfx/system/startup.mp3"
      [wifi_connected]="$HOME/nixo/resources/sfx/system/network_connected.mp3"
      [wifi_disconnected]="$HOME/nixo/resources/sfx/system/network_disconnected.mp3"
      [cpu_overload]="$HOME/nixo/resources/sfx/system/cpu_overload.mp3"
      [nix_build_failed]="$HOME/nixo/resources/sfx/system/warning.mp3"
      [nix_build_ok]="$HOME/nixo/resources/sfx/system/build_success.mp3"
      [nix_build_start]="$HOME/nixo/resources/sfx/system/build_start.mp3"
      [warn]="$HOME/nixo/resources/sfx/system/warning.mp3"
      [notif]="$HOME/nixo/resources/sfx/system/notification.mp3"
      
      # --- Power Events ---
      [charging]="$HOME/nixo/resources/sfx/power/charging.mp3"
      [discharging]="$HOME/nixo/resources/sfx/power/discharging.mp3"
      [max_pwr]="$HOME/nixo/resources/sfx/power/performance.mp3"
      [max_save]="$HOME/nixo/resources/sfx/power/power_saving.mp3"
      [conserve_on]="$HOME/nixo/resources/sfx/power/battery_conserve_on.mp3"
      [conserve_off]="$HOME/nixo/resources/sfx/power/battery_conserve_off.mp3"
      [10]="$HOME/nixo/resources/sfx/power/10.mp3"
      [20]="$HOME/nixo/resources/sfx/power/20.mp3"
      [30]="$HOME/nixo/resources/sfx/power/30.mp3"
      [40]="$HOME/nixo/resources/sfx/power/40.mp3"
      [50]="$HOME/nixo/resources/sfx/power/50.mp3"
      [60]="$HOME/nixo/resources/sfx/power/60.mp3"
      [70]="$HOME/nixo/resources/sfx/power/70.mp3"
      [80]="$HOME/nixo/resources/sfx/power/80.mp3"
      [90]="$HOME/nixo/resources/sfx/power/90.mp3"
      [100]="$HOME/nixo/resources/sfx/power/100.mp3"
  
      # --- Hardware / VFIO / dGPU ---
      [detached]="$HOME/nixo/resources/sfx/hardware/detached.mp3"
      [reattached]="$HOME/nixo/resources/sfx/hardware/reattached.mp3"
      [vfio_on]="$HOME/nixo/resources/sfx/hardware/detached.mp3"
      [vfio_off]="$HOME/nixo/resources/sfx/hardware/vfio_off.mp3"
      [vfio_fail]="$HOME/nixo/resources/sfx/hardware/vfio_fail.mp3"
      [dgpu_back]="$HOME/nixo/resources/sfx/dgpu_back.mp3"
      [dgpu_pass]="$HOME/nixo/resources/sfx/dgpu_pass.mp3"
  
      # --- Windows / VM ---
      [windows_on]="$HOME/nixo/resources/sfx/windows_on.mp3"
      [windows_off]="$HOME/nixo/resources/sfx/windows_off.mp3"
      
      # --- Generic ---
      [error]="$HOME/nixo/resources/sfx/error.mp3"
    )
  
    show_help() {
      echo "NotifX1 Event Sound Manager"
      echo "----------------------------"
      echo "Plays specific sound effects for system events."
      echo ""
      echo "Usage: notifx1 <event>"
      echo "   or: notifx1 [ -h | --help ]"
      echo ""
      echo "Available Events:"
      # Loop through keys (!sounds[@]), sort them, and print
      for key in $(echo "''${!sounds[@]}" | tr ' ' '\n' | sort); do
          echo "  - $key"
      done
      exit 0
    }
  
    # Handle help flags or missing arguments
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
      show_help
    fi
  
    if [[ -z "$1" ]]; then
      echo "Error: No event provided."
      show_help
    fi
  
    # Check if the event exists in the array
    if [[ -n "''${sounds[$1]}" ]]; then
      # Check if the actual file exists before playing
      if [[ -f "''${sounds[$1]}" ]]; then
        paplay "''${sounds[$1]}"
      else
        echo "Error: File not found: ''${sounds[$1]}"
        exit 1
      fi
    else
      echo "Error: Unknown event '$1'"
      echo "Run 'notifx1 -h' for a list of valid events."
      exit 1
    fi
  '';
in
{
  imports = [ ./warn.nix ];

  environment.systemPackages = with pkgs; [ prophet_events ];

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "wifiSoundHook" ''
        #!/usr/bin/env bash
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
    #  ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/systemd-run --user --machine=${user.name}@ ${pkgs.bash}/bin/bash -c 'wall-aware to_swww'"
    '';
  };
}