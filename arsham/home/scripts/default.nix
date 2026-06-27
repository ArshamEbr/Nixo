{ config, lib, pkgs, ... }:

let
  cfg = config.services.wallpaper-manager;

  wallpaperManagerPkg = pkgs.writeShellApplication {
    name = "wallpaper-manager";
    runtimeInputs = with pkgs; [
      coreutils
      procps
      gnugrep
      mpvpaper
      swww
    ] ++ lib.optionals cfg.useLibvirt [ pkgs.libvirt ];

    text = ''
      VIDEO_WALLPAPER="${cfg.videoWallpaper}"
      STATIC_WALLPAPER="${cfg.staticWallpaper}"
      DISPLAY_OUTPUT="${cfg.displayOutput}"
      VM_NAME="${cfg.vmName}"

      log() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
      }

      is_on_ac_power() {
        for adapter in /sys/class/power_supply/AC* /sys/class/power_supply/ADP* /sys/class/power_supply/ACAD*; do
          if [[ -f "$adapter/online" ]] && [[ "$(cat "$adapter/online")" == "1" ]]; then
            return 0
          fi
        done

        for battery in /sys/class/power_supply/BAT*; do
          if [[ -f "$battery/status" ]]; then
            status=$(cat "$battery/status")
            if [[ "$status" == "Charging" || "$status" == "Full" || "$status" == "Not charging" ]]; then
              return 0
            fi
          fi
        done

        return 1
      }

      is_vm_running() {
        ${lib.optionalString cfg.useLibvirt ''
        if virsh list --name 2>/dev/null | grep -q "^''${VM_NAME}$"; then
          return 0
        fi
        ''}

        if pgrep -f "qemu.*''${VM_NAME}" &>/dev/null; then
          return 0
        fi

        if pgrep -f "looking-glass" &>/dev/null; then
          return 0
        fi

        return 1
      }

      start_mpvpaper() {
        log "Starting mpvpaper with $VIDEO_WALLPAPER"
        mpvpaper -o "no-audio loop" "$DISPLAY_OUTPUT" "$VIDEO_WALLPAPER" &
        disown
        sleep 1

        log "Killing swww-daemon..."
        pkill swww-daemon || true
      }

      start_swww() {
        log "Starting swww-daemon"
        swww-daemon --format xrgb &
        disown
        sleep 1

        log "Setting static wallpaper: $STATIC_WALLPAPER"
        swww img "$STATIC_WALLPAPER" \
          --transition-type "${cfg.swwwTransition}" \
          --transition-duration "${toString cfg.transitionDuration}"
        sleep 0.5

        log "Killing mpvpaper..."
        pkill mpvpaper || true
      }

      main() {
        local on_ac=false
        local vm_running=false

        is_on_ac_power && on_ac=true
        is_vm_running && vm_running=true

        log "Status: AC=$on_ac, VM_Running=$vm_running"

        if $vm_running; then
          log "VM running - switching to static wallpaper"
          start_swww
        elif $on_ac; then
          log "On AC power, no VM - switching to live wallpaper"
          start_mpvpaper
        else
          log "On battery - switching to static wallpaper"
          start_swww
        fi
      }

      main
    '';
  };

  wallpaperDaemonPkg = pkgs.writeShellApplication {
    name = "wallpaper-daemon";
    runtimeInputs = with pkgs; [
      coreutils
      procps
      gnugrep
    ] ++ lib.optionals cfg.useLibvirt [ pkgs.libvirt ];

    text = ''
      CHECK_INTERVAL=${toString cfg.checkInterval}
      VM_NAME="${cfg.vmName}"

      prev_ac_state=""
      prev_vm_state=""

      get_ac_state() {
        for adapter in /sys/class/power_supply/AC* /sys/class/power_supply/ADP* /sys/class/power_supply/ACAD*; do
          if [[ -f "$adapter/online" ]]; then
            cat "$adapter/online"
            return
          fi
        done

        for battery in /sys/class/power_supply/BAT*; do
          if [[ -f "$battery/status" ]]; then
            status=$(cat "$battery/status")
            if [[ "$status" == "Discharging" ]]; then
              echo "0"
            else
              echo "1"
            fi
            return
          fi
        done
        echo "1"
      }

      get_vm_state() {
        ${lib.optionalString cfg.useLibvirt ''
        if virsh list --name 2>/dev/null | grep -q "^''${VM_NAME}$"; then
          echo "1"
          return
        fi
        ''}

        if pgrep -f "qemu.*''${VM_NAME}" &>/dev/null; then
          echo "1"
        else
          echo "0"
        fi
      }

      echo "[$(date '+%Y-%m-%d %H:%M:%S')] Wallpaper daemon started"

      # Initial run
      ${lib.getExe wallpaperManagerPkg}
      prev_ac_state=$(get_ac_state)
      prev_vm_state=$(get_vm_state)

      while true; do
        sleep "$CHECK_INTERVAL"

        current_ac_state=$(get_ac_state)
        current_vm_state=$(get_vm_state)

        if [[ "$current_ac_state" != "$prev_ac_state" ]] || [[ "$current_vm_state" != "$prev_vm_state" ]]; then
          echo "[$(date '+%Y-%m-%d %H:%M:%S')] State change: AC $prev_ac_state->$current_ac_state, VM $prev_vm_state->$current_vm_state"
          ${lib.getExe wallpaperManagerPkg}
          prev_ac_state="$current_ac_state"
          prev_vm_state="$current_vm_state"
        fi
      done
    '';
  };

in {
  options.services.wallpaper-manager = {
    enable = lib.mkEnableOption "power-aware wallpaper manager";

    videoWallpaper = lib.mkOption {
      type = lib.types.str;
      description = "Path to video wallpaper file";
      example = "/home/user/Videos/wallpaper.mp4";
    };

    staticWallpaper = lib.mkOption {
      type = lib.types.str;
      description = "Path to static wallpaper image";
      example = "/home/user/Pictures/wallpaper.png";
    };

    displayOutput = lib.mkOption {
      type = lib.types.str;
      default = "*";
      description = "Display output for mpvpaper (* for all)";
    };

    vmName = lib.mkOption {
      type = lib.types.str;
      default = "win10";
      description = "Name of Windows VM to monitor";
    };

    useLibvirt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use libvirt/virsh for VM detection";
    };

    checkInterval = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Interval in seconds between state checks";
    };

    swwwTransition = lib.mkOption {
      type = lib.types.str;
      default = "fade";
      description = "Transition type for swww";
    };

    transitionDuration = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Transition duration in seconds";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      wallpaperManagerPkg
      wallpaperDaemonPkg
      pkgs.mpvpaper
      pkgs.swww
    ];

    systemd.user.services.wallpaper-manager = {
      Unit = {
        Description = "Power-aware wallpaper manager";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe wallpaperDaemonPkg}";
        Restart = "on-failure";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}