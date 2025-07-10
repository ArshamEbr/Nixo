{ 
  pkgs,
  user, 
  ... 
}:

let
  prophet_events = pkgs.writeShellScriptBin "notifx1" ''
    #!/run/current-system/sw/bin/bash
    
    case "$1" in
    
        usb_add) paplay ~/nixo/resources/sfx/system/hardware_add.mp3 ;;
        usb_remove) paplay ~/nixo/resources/sfx/system/hardware_remove.mp3 ;;
        
        startup) paplay ~/nixo/resources/sfx/system/startup.mp3 ;;
        
        wifi_connected) paplay ~/nixo/resources/sfx/system/network_connected.mp3 ;;
        wifi_disconnected) paplay ~/nixo/resources/sfx/system/network_disconnected.mp3 ;;
        
        charging) paplay ~/nixo/resources/sfx/power/charging.mp3 ;;
        discharging) paplay ~/nixo/resources/sfx/power/discharging.mp3 ;;
        
        max_pwr) paplay ~/nixo/resources/sfx/power/performance.mp3 ;;
        max_save) paplay ~/nixo/resources/sfx/power/power_saving.mp3 ;;
        
        conserve_on) paplay ~/nixo/resources/sfx/power/battery_conserve_on.mp3 ;;
        conserve_off) paplay ~/nixo/resources/sfx/power/battery_conserve_off.mp3 ;;
        
        detached) paplay ~/nixo/resources/sfx/hardware/detached.mp3 ;;
        reattached) paplay ~/nixo/resources/sfx/hardware/reattached.mp3 ;;
        vfio_on) paplay ~/nixo/resources/sfx/hardware/detached.mp3 ;;
        vfio_off) paplay ~/nixo/resources/sfx/hardware/vfio_off.mp3 ;;
        vfio_fail) paplay ~/nixo/resources/sfx/hardware/vfio_fail.mp3 ;;
        
        cpu_overload) paplay ~/nixo/resources/sfx/system/cpu_overload.mp3 ;;
        
        nix_build_failed) paplay ~/nixo/resources/sfx/system/warning.mp3 ;;
        nix_build_ok) paplay ~/nixo/resources/sfx/system/build_sucess.mp3 ;;
        nix_build_start) paplay ~/nixo/resources/sfx/system/build_start.mp3 ;;
        
        warn) paplay ~/nixo/resources/sfx/system/warning.mp3 ;;
        notif) paplay ~/nixo/resources/sfx/system/notification.mp3 ;;
        
        10) paplay ~/nixo/resources/sfx/power/10.mp3 ;;
        20) paplay ~/nixo/resources/sfx/power/20.mp3 ;;
        30) paplay ~/nixo/resources/sfx/power/30.mp3 ;;
        40) paplay ~/nixo/resources/sfx/power/40.mp3 ;;
        50) paplay ~/nixo/resources/sfx/power/50.mp3 ;;
        60) paplay ~/nixo/resources/sfx/power/60.mp3 ;;
        70) paplay ~/nixo/resources/sfx/power/70.mp3 ;;
        80) paplay ~/nixo/resources/sfx/power/80.mp3 ;;
        90) paplay ~/nixo/resources/sfx/power/90.mp3 ;;
        100) paplay ~/nixo/resources/sfx/power/100.mp3 ;;
        
        *) echo "Unknown event: $1" ;;
    esac
  '';
in
{
  
  imports = [./warn.nix];
  
  environment.systemPackages = with pkgs; [
    prophet_events
  ];
  
  networking.networkmanager = {
    dispatcherScripts = [
      {
        source = pkgs.writeText "wifiSoundHook" ''
          #!/run/current-system/sw/bin/bash
          
          STATE_FILE="/tmp/network_state_$1"
          CURRENT_STATE="$2"
          
          if [[ -f "$STATE_FILE" ]]; then
            PREVIOUS_STATE=$(cat "$STATE_FILE")
          else
            PREVIOUS_STATE="none"
          fi
          
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
  };
  
  services = {
    
    battery-events = {
      enable = true;
    };
    
    overheat-alert = {
      enable = true;
      temperatureThreshold = 100;
    };
    
    low-ram-warning = {
      enable = false;
      ramThreshold = 1500;
    };
    
    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 usb_add & disown"
        ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 usb_remove & disown"
        ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 charging & disown"
        ACTION=="change", SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 discharging & disown"
      '';
    };
  };
}