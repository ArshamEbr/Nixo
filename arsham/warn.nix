{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.overheat-warning;
in
{
  options = {
    services.overheat-warning = {
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

      soundPath = mkOption {
        type = types.str;
        default = "/path/to/your/overheat-warning-sound.ogg";
        description = "Path to the sound file to play when the CPU overheats.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.stdenv.mkDerivation {
        name = "overheat-warning";
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out/bin
          cat > $out/bin/overheat-warning <<'EOF'
          #!/run/current-system/sw/bin/bash
          set -x

          TEMP_THRESHOLD=${toString cfg.temperatureThreshold}

          CPU_TEMP=$(sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//;s/°C//')

          if (( $(echo "$CPU_TEMP > $TEMP_THRESHOLD" | bc -l) )); then
            notifx1 cpu_overload
            notify-send "CPU Overheating Warning!" "CPU temperature is $CPU_TEMP°C" --icon=dialog-warning
            sudo tlp bat
          fi
          EOF
          chmod 755 $out/bin/overheat-warning
        '';
      })
    ];

    systemd.services.overheat-warning = {
      description = "CPU Overheating Warning Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do ${config.environment.systemPackages.overheat-warning}/bin/overheat-warning; sleep 60; done'";
        Restart = "always";
      };
    };
  };
}