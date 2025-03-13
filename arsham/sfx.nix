{ pkgs, pkgs-unstable, config, ... }:
let

  prophet_events = pkgs.writeShellScriptBin "notifx1" ''
    #!/run/current-system/sw/bin/bash
  
    case "$1" in

        usb_add) paplay ~/nixo/resources/sfx/system/usb-add.mp3 ;;
        usb_remove) paplay ~/nixo/resources/sfx/system/usb-remove.mp3 ;;

        startup) paplay ~/nixo/resources/sfx/startup7.wav ;;

        wifi_connected) paplay ~/nixo/resources/sfx/system/wifi-connected.mp3 ;;
        wifi_disconnected) paplay ~/nixo/resources/sfx/system/wifi-disconnected.mp3 ;;

        charging) paplay ~/nixo/resources/sfx/power/charging.mp3 ;;
        discharging) paplay ~/nixo/resources/sfx/power/discharging.mp3 ;;

        max_pwr) paplay ~/nixo/resources/sfx/power/maximum_power.mp3 ;;
        max_save) paplay ~/nixo/resources/sfx/power/maximum_save.mp3 ;;

        conserve_on) paplay ~/nixo/resources/sfx/power/conserve_on.mp3 ;;
        conserve_off) paplay ~/nixo/resources/sfx/power/conserve_off.mp3 ;;

        detached) paplay ~/nixo/resources/sfx/hardware/detached.mp3 ;;
        reattached) paplay ~/nixo/resources/sfx/hardware/reattached.mp3 ;;
        vfio_on) paplay ~/nixo/resources/sfx/hardware/detached.mp3 ;;
        vfio_off) paplay ~/nixo/resources/sfx/hardware/vfio_off.mp3 ;;
        vfio_fail) paplay ~/nixo/resources/sfx/hardware/vfio_fail.mp3 ;;

        cpu_overload) paplay ~/nixo/resources/sfx/system/cpu_overload.mp3 ;;

        nix_build_failed) paplay ~/nixo/resources/sfx/error.mp3 ;;
        nix_build_ok) paplay ~/nixo/resources/sfx/audio.mp3 ;;
        nix_build_start) paplay ~/nixo/resources/sfx/notif.mp3 ;;

        10) paplay ~/nixo/resources/sfx/power/10.mp3 ;;
        20) paplay ~/nixo/resources/sfx/power/20.mp3 ;;
        25) paplay ~/nixo/resources/sfx/power/25.mp3 ;;
        40) paplay ~/nixo/resources/sfx/power/40.mp3 ;;
        50) paplay ~/nixo/resources/sfx/power/50.mp3 ;;
        60) paplay ~/nixo/resources/sfx/power/60.mp3 ;;
        75) paplay ~/nixo/resources/sfx/power/75.mp3 ;;
        80) paplay ~/nixo/resources/sfx/power/80.mp3 ;;
        90) paplay ~/nixo/resources/sfx/power/90.mp3 ;;
        100) paplay ~/nixo/resources/sfx/power/100.mp3 ;;
        
        *) echo "Unknown event: $1" ;;
    esac
  '';
  sound_cycler = pkgs.writeShellScriptBin "sound_cycle" ''
    #!/run/current-system/sw/bin/bash

    SOUND_DIR="$HOME/sfxo"
    STATE_FILE="/tmp/usb_sound_index"
    COUNT_FILE="/tmp/usb_event_count"
    TOTAL_FOLDERS=12  
    
    if [ ! -f "$STATE_FILE" ]; then
        echo "1" > "$STATE_FILE"
    fi
    if [ ! -f "$COUNT_FILE" ]; then
        echo "0" > "$COUNT_FILE"
    fi
    
    CURRENT_INDEX=$(cat "$STATE_FILE")
    EVENT_COUNT=$(cat "$COUNT_FILE")  # Keeps track of USB plug-ins
    
    case "$1" in
        "usb_add")
            SOUND_FILE="$SOUND_DIR/sfx$CURRENT_INDEX/Hardware_Insert.wav"
            EVENT_COUNT=$((EVENT_COUNT + 1))  # Increment for each plug-in
            ;;
        "usb_remove")
            SOUND_FILE="$SOUND_DIR/sfx$CURRENT_INDEX/Hardware_Remove.wav"
            EVENT_COUNT=$((EVENT_COUNT - 1))  # Decrement for each unplug
            ;;
        "usb_fail")
            SOUND_FILE="$SOUND_DIR/sfx$CURRENT_INDEX/Hardware_Fail.wav"
            ;;
        *)
            echo "Invalid argument. Use: usb_add, usb_remove, or usb_fail"
            exit 1
            ;;
    esac
    
    if [ -f "$SOUND_FILE" ]; then
        paplay "$SOUND_FILE"
    else
        echo "Error: Sound file not found: $SOUND_FILE"
    fi
    
    echo "$EVENT_COUNT" > "$COUNT_FILE"
    
    if [ "$EVENT_COUNT" -eq 0 ]; then
        while :; do
            RANDOM_INDEX=$((RANDOM % TOTAL_FOLDERS + 1))
            if [ "$RANDOM_INDEX" -ne "$CURRENT_INDEX" ]; then
                break
            fi
        done
    
        echo "$RANDOM_INDEX" > "$STATE_FILE"  # Save the new sound folder
    fi
  '';

in

  {

  imports = [./warn.nix];

    environment.systemPackages = with pkgs; [
      prophet_events
      sound_cycler
    ];

    networking.networkmanager = {
      dispatcherScripts = [
        {
      source = pkgs.writeText "wifiSoundHook" ''
        #!/run/current-system/sw/bin/bash

        # Store the previous state in a file
        STATE_FILE="/tmp/network_state_$1"

        # Get the current state
        CURRENT_STATE="$2"

        # Read the previous state
        if [[ -f "$STATE_FILE" ]]; then
          PREVIOUS_STATE=$(cat "$STATE_FILE")
        else
          PREVIOUS_STATE="none"
        fi

        # Only act if the state has changed
        if [[ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]]; then
          case "$CURRENT_STATE" in
            up)
              ${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 wifi_connected
              ;;
            down)
              ${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 wifi_disconnected
              ;;
          esac

          # Save the current state
          echo "$CURRENT_STATE" > "$STATE_FILE"
        fi
      '';
      type = "basic";
    }
      ];
    };

    services = {

      battery-events = {
        enable = true;
      };

      overheat-alert = {
        enable = true;
        temperatureThreshold = 90;
      };

      low-ram-warning = {
        enable = false;
        ramThreshold = 1500;
      };
  
      udev = {
        extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash sound_cycle usb_add"
          ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash sound_cycle usb_remove"
          ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 charging & disown"
          ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/machinectl shell arsham@ ${pkgs.bash}/bin/bash notifx1 discharging & disown"
        '';
      };
    };
  }