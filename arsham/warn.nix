{ config, pkgs, lib, user, ... }:

with lib;

let
  overheat-alert-script = pkgs.writeScriptBin "overheat-alert" ''
    #!/run/current-system/sw/bin/bash
    set -x

    TEMP_THRESHOLD=${toString config.services.overheat-alert.temperatureThreshold}

    CPU_TEMP=$(${pkgs.lm_sensors}/bin/sensors | ${pkgs.gawk}/bin/awk '/Package id 0:/ {print $4}' | ${pkgs.gnused}/bin/sed 's/+//;s/°C//')

    if (( $(echo "$CPU_TEMP > $TEMP_THRESHOLD" | ${pkgs.bc}/bin/bc -l) )); then
      echo "CPU temperature is $CPU_TEMP°C (above threshold: $TEMP_THRESHOLD°C)"
      ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.libnotify}/bin/notify-send "CPU Overheating Warning!" "CPU temperature is $CPU_TEMP°C" --icon=dialog-warning
      ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 cpu_overload
      ${pkgs.tlp}/bin/tlp bat
    else
      echo "CPU temperature is $CPU_TEMP°C (below threshold: $TEMP_THRESHOLD°C)"
    fi
  '';

  low-ram-warning-script = pkgs.writeScriptBin "low-ram-warning" ''
    #!/run/current-system/sw/bin/bash
    set -x

    RAM_THRESHOLD=${toString config.services.low-ram-warning.ramThreshold}

    FREE_RAM=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk '/Mem:/ { print $7 }')

    if (( FREE_RAM < RAM_THRESHOLD )); then
      echo "Low RAM Warning: Only $FREE_RAM MB left (Threshold: $RAM_THRESHOLD MB)"
      ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.libnotify}/bin/notify-send "Low RAM Warning!" "Only $FREE_RAM MB available!" --icon=dialog-warning
      ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 low_ram
    else
      echo "RAM is sufficient: $FREE_RAM MB available"
    fi
  '';

  battery-events-script = pkgs.writeShellScriptBin "bat-percentage-check" ''
    #!/run/current-system/sw/bin/bash
    
    last_notified_level=-1
    
    while true; do
        battery_percentage=$(< /sys/class/power_supply/BAT0/capacity)
    
        if (( battery_percentage != last_notified_level )); then
            case $battery_percentage in
                10|20|50|80)
                    ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash notifx1 "$battery_percentage"
                    ;;
                65)
                    ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash battery_toggle off
                    ;;
                85)
                    ${pkgs.systemd}/bin/machinectl shell ${user.name}@ ${pkgs.bash}/bin/bash battery_toggle on
                    ;;
            esac
            last_notified_level=$battery_percentage
        fi
    
        # Poll faster if close to any key level
        if (( battery_percentage % 10 >= 8 || battery_percentage % 10 <= 2 )); then
            sleep 13
        else
            sleep 60
        fi
    done
    
  '';

in
{
  options = {
    services.overheat-alert = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the CPU overheating warning service.";
      };

      temperatureThreshold = mkOption {
        type = types.int;
        default = 80;
        description = "CPU temperature threshold (in Celsius) to trigger the warning.";
      };
    };

    services.low-ram-warning = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the low RAM warning service.";
      };

      ramThreshold = mkOption {
        type = types.int;
        default = 1024; # Default: 500 MB
        description = "Available RAM threshold (in MB) to trigger the warning.";
      };
    };

    services.battery-events = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the battery events service.";
      };
    };

  };

  config = mkMerge [
                    
    (mkIf config.services.overheat-alert.enable {
      environment.systemPackages = [ overheat-alert-script ];
      
      systemd.services.overheat-alert = {
        description = "CPU Overheating Warning Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${overheat-alert-script}/bin/overheat-alert; sleep 30; done'";
          Environment = "XDG_RUNTIME_DIR=/run/user/1000";
          Restart = "always";
        };
      };
    })
    
    (mkIf config.services.low-ram-warning.enable {
      environment.systemPackages = [ low-ram-warning-script ];
    
      systemd.services.low-ram-warning = {
        description = "Low RAM Warning Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${low-ram-warning-script}/bin/low-ram-warning; sleep 30; done'";
          Environment = "XDG_RUNTIME_DIR=/run/user/1000";
          Restart = "always";
        };
      };
    })
    
    (mkIf config.services.battery-events.enable {
      environment.systemPackages = [ battery-events-script ];
    
      systemd.services.battery-events = {
        description = "Play sound based on battery percentage";
        serviceConfig = {
          ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${battery-events-script}/bin/bat-percentage-check; sleep 30; done'";
          Environment = "XDG_RUNTIME_DIR=/run/user/1000";
          Restart = "always";
        };
      wantedBy = [ "default.target" ];
    };
    })

  ];
}