{ pkgs, ... }:
let

  dGPU_VFIO = pkgs.stdenv.mkDerivation {
    name = "dGPU_VFIO";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/check_gpu_status <<'ENDX1'
      ############################
      #                          #
      #    Check dGPU Status     #
      #                          #
      ############################
      #!/run/current-system/sw/bin/bash
      set -x
      vfio_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'vfio-pci')
      if [[ -n "$vfio_status" ]]; then
        notify-send "NVIDIA dGPU is Passed Through" --icon=$HOME/nixo/resources/icons/nvidia.png
        notifx1 detached & disown
      else
        nvidia_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'nvidia')
        if [[ -n "$nvidia_status" ]]; then
          notify-send "NVIDIA dGPU is Under Control" --icon=$HOME/nixo/resources/icons/lgpu.png
          notifx1 vfio_off & disown
        else
          notify-send "NVIDIA dGPU is in an Unknown State" --icon=$HOME/nixo/resources/icons/report.png
          notifx1 vfio_fail & disown
        fi
      fi
      ENDX1
      chmod 755 $out/bin/check_gpu_status
      cat > $out/bin/dettach_safe <<'ENDX2'
      ############################
      #                          #
      #    Detach dGPU Safely    #
      #                          #
      ############################
      #!/run/current-system/sw/bin/bash
      set -x
  
      # Check if NVIDIA dGPU is already detached
      driver=$(lspci -nnk -d 10de:1c94 | grep "Kernel driver in use" | awk -F': ' '{print $2}')
      if [[ "$driver" == "vfio-pci" ]]; then
        notify-send "NVIDIA dGPU is Already Detached" --icon=$HOME/nixo/resources/icons/gpu.png
        paplay ~/nixo/resources/sfx/notif.mp3 & disown
        exit 0
      fi
  
      # Check for processes using /dev/nvidia0
      nvidia_processes=$(lsof /dev/nvidia* | awk 'NR>1 {print $1, $2}' | sort -u)
      if [ -n "$nvidia_processes" ]; then
        notify-send -t 10000 "The following processes are using dGPU:" "\n$nvidia_processes" --icon=$HOME/nixo/resources/icons/warning.png
        paplay ~/nixo/resources/sfx/error.mp3 & disown
        echo "dGPU detach aborted: processes using /dev/nvidia0:"
        echo "$nvidia_processes"
        exit 1
      fi
  
      # Check for compute processes using nvidia-smi
      pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader | xargs)
      if [ -n "$pids" ]; then
        notify-send -t 10000 "dGPU Detach Aborted" "The following compute processes are using the dGPU:\n$pids" --icon=$HOME/nixo/resources/icons/warning.png
        paplay ~/nixo/resources/sfx/error.mp3 & disown
        echo "dGPU detach aborted: compute processes running: $pids"
        exit 1
      fi
  
      # Detach the dGPU
      sudo systemctl stop ollama
      sudo rmmod nvidia_modeset nvidia_uvm nvidia
      sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
      sudo virsh nodedev-detach pci_0000_01_00_0
      notify-send "NVIDIA dGPU is Detached" --icon=$HOME/nixo/resources/icons/nvidia.png
      paplay ~/nixo/resources/sfx/detach.mp3 & disown
      exit
      ENDX2
      chmod 755 $out/bin/dettach_safe
      cat > $out/bin/reattach_safe <<'ENDX3'
      ############################
      #                          #
      #   Reattach dGPU Safely   #
      #                          #
      ############################
      #!/run/current-system/sw/bin/bash
      set -x
      driver=$(lspci -nnk -d 10de:1c94 | grep "Kernel driver in use" | awk -F': ' '{print $2}') 
      if [[ "$driver" == "nvidia" ]]; then
        notify-send "NVIDIA dGPU is already attached" --icon=$HOME/nixo/resources/icons/lgpu.png
        paplay ~/nixo/resources/sfx/notif.mp3 & disown
        exit 0
      fi
      sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1
      sudo virsh nodedev-reattach pci_0000_01_00_0
      sudo modprobe -i nvidia_modeset nvidia_uvm nvidia
      notify-send "NVIDIA dGPU is Reattached" --icon=$HOME/nixo/resources/icons/nvidia.png
      paplay ~/nixo/resources/sfx/attach.mp3 & disown
      sudo systemctl restart ollama
      exit
      ENDX3
      chmod 755 $out/bin/reattach_safe
    '';
  };
  
  Battery_Related = pkgs.stdenv.mkDerivation {
    name = "Battery_Related";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/battery_toggle <<'ENDX1'
      #################################
      #                               #
      #   Battery Conservation Mode   #
      #                               #
      #################################
      #!/run/current-system/sw/bin/bash
      set -x
  
      # Function to turn conservation mode on
      conserve_on() {
        sudo tlp setcharge 0 1
        notifx1 conserve_on & disown
        notify-send "Battery Conservation Mode ON" --icon=$HOME/nixo/resources/icons/conserve_on.png
      }
  
      # Function to turn conservation mode off
      conserve_off() {
        sudo tlp setcharge 0 0
        notifx1 conserve_off & disown
        notify-send "Battery Conservation Mode OFF" --icon=$HOME/nixo/resources/icons/conserve_off.png
      }
  
      # Check for manual arguments
      if [[ "$1" == "on" ]]; then
        conserve_on
      elif [[ "$1" == "off" ]]; then
        conserve_off
      else
        # If no argument, toggle based on current state
        current_state=$(cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
        if [[ "$current_state" == "1" ]]; then
          conserve_off
        else
          conserve_on
        fi
      fi
      ENDX1
      chmod 755 $out/bin/battery_toggle
      cat > $out/bin/tlp_mode <<'ENDX2'
      ############################
      #                          #
      #    Change TLP Profile    #
      #                          #
      ############################
      #!/run/current-system/sw/bin/bash
      set -x
      current_mode=$(tlp-stat -s | grep "Mode" | awk '{print $3}')
      if [[ "$current_mode" == "battery" ]]; then
          new_mode="ac"
          mode_name="Maximum Performance"
          notifx1 max_pwr & disown
          icon=$HOME/nixo/resources/icons/performance.png
          swww img $HOME/nixo/resources/wallpapers/mitsu.png --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1
      else
          new_mode="bat"
          mode_name="Maximum Power Saving"
          notifx1 max_save & disown
          icon=$HOME/nixo/resources/icons/power_saving.png
          swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1
      fi
      sudo tlp "$new_mode"
      notify-send "Power Mode Switched!" "Now in $mode_name mode" --icon=$icon
      ENDX2
      chmod 755 $out/bin/tlp_mode
      cat > $out/bin/battery_percent <<'ENDX3'
      ################################
      #                              #
      #      Battery Percentage      #
      #  For Displaying On Hyprlock  #
      #                              #
      ################################
      #!/run/current-system/sw/bin/bash
      set -x
      #Variables
      enable_battery=false
      battery_charging=false
      
      #Check availability
      for battery in /sys/class/power_supply/*BAT*; do
        if [[ -f "$battery/uevent" ]]; then
          enable_battery=true
          if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
            battery_charging=true
          fi
          break
        fi
      done
      
      #Output
      if [[ $enable_battery == true ]]; then
        if [[ $battery_charging == true ]]; then
          echo -n "Charging >:) "
        fi
        echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
        if [[ $battery_charging == false ]]; then
          echo -n " Remaining :("
        fi
      fi
      echo ""
      ENDX3
      chmod 755 $out/bin/battery_percent
    '';
  };
  
  Windows_VM = pkgs.stdenv.mkDerivation {
    name = "Windows_VM";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/dgpu_windows_vm_start <<'ENDX1'
      ###############################
      #                             #
      #    Detach dGPU and start    #
      #       the windows VM        #
      #                             #
      ###############################
      #!/run/current-system/sw/bin/bash
      set -x
      dettach_safe
      exit_code=$?
      if [ $exit_code -ne 0 ]; then
          notify-send "Windows Boot aborted!" --icon=$HOME/nixo/resources/icons/error.png
          exit 1
      fi
      pkill mpvpaper
      swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1 & disown
      virsh -c qemu:///system start Win11
      looking-glass-client -F & disown
      notify-send "Windows VM is Booting UP!" --icon=$HOME/nixo/resources/icons/windows.png
      paplay ~/nixo/resources/sfx/windows_on.mp3 & disown
      exit
      ENDX1
      chmod 755 $out/bin/dgpu_windows_vm_start
      cat > $out/bin/dgpu_windows_vm_shutdown <<'ENDX2'
      ###############################
      #                             #
      #   Shutdown the windows VM   #
      #    and reattach the dGPU    #
      #                             #
      ###############################
      #!/run/current-system/sw/bin/bash
      set -x
      pkill swaybg

      # pgrep mpvpaper > /dev/null || mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes' & disown
      swww img $HOME/nixo/resources/wallpapers/mitsu.png --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1 & disown
      virsh -c qemu:///system shutdown Win11 
      virsh -c qemu:///system shutdown Win11_iAudio
      notify-send "Shutdown initiated for Windows VM" --icon=$HOME/nixo/resources/icons/close.png
      max_wait=10
      waited=0
      while true; do
          state_win11=$(virsh -c qemu:///system domstate Win11 2>/dev/null)
          state_audio_win11=$(virsh -c qemu:///system domstate Win11_iAudio 2>/dev/null)     
          if [[ "$state_win11" == "shut off" && "$state_audio_win11" == "shut off" ]]; then
              break
          fi    
          sleep 2
          waited=$((waited+2))     
          if (( waited >= max_wait )); then
              notify-send "Timeout waiting for Windows VM to shut down. GPU reattach aborted." --icon=$HOME/nixo/resources/icons/report.png
              paplay ~/nixo/resources/sfx/error.mp3 & disown
              exit 1
          fi
      done     
      pkill -f looking-glass-client 
      notify-send "Windows VM is completely shutdown!" --icon=$HOME/nixo/resources/icons/shutdown.png
      paplay ~/nixo/resources/sfx/windows_off.mp3 & disown
      reattach_safe & disown
      iaudio_reattach & disown
      exit
      ENDX2
      chmod 755 $out/bin/dgpu_windows_vm_shutdown
      cat > $out/bin/iaudio_reattach <<'ENDX3'
      ###############################
      #                             #
      #   Reattach the internal     #
      #          Speakers           #
      #                             #
      ###############################
      #!/run/current-system/sw/bin/bash 
      set -x
      driver=$(lspci -nnk -d 8086:a0c8 | grep "Kernel driver in use" | awk -F': ' '{print $2}')
      if [[ "$driver" == "sof-audio-pci-intel-tgl" ]]; then
        notify-send "Speakers already attached" --icon=audio-volume-high
        paplay ~/nixo/resources/sfx/notif.mp3 & disown
        exit 0
      fi
      DEVICES=("pci_0000_00_1f_0" "pci_0000_00_1f_3" "pci_0000_00_1f_4" "pci_0000_00_1f_5")   
      failed=false
      for dev in "''${DEVICES[@]}"; do
        if ! sudo virsh nodedev-reattach "$dev"; then
          notify-send "Failed to reattach $dev" --icon=dialog-warning
          failed=true
        fi
      done
      if [[ "$failed" == false ]]; then
        notify-send "Speakers Reattached" --icon=$HOME/nixo/resources/icons/sound.png
        paplay ~/nixo/resources/sfx/audio.mp3 & disown
      else
        notify-send "Some devices failed to reattach!" --icon=audio-volume-muted
      fi
      exit
      ENDX3
      chmod 755 $out/bin/iaudio_reattach
      cat > $out/bin/iaudio_deattach <<'ENDX4'
      ##############################
      #                            #
      #   Dettach the internal     #
      #    Speakers for Dolby      #
      #  experiance in windows VM  #
      #                            #
      ##############################
      #!/run/current-system/sw/bin/bash
      set -x
      driver=$(lspci -nnk -d 8086:a0c8 | grep "Kernel driver in use" | awk -F': ' '{print $2}') 
      if [[ "$driver" == "vfio-pci" ]]; then
        notify-send "Speakers already detached" --icon=$HOME/nixo/resources/icons/sound.png
        exit 0
      fi
      DEVICES=("pci_0000_00_1f_0" "pci_0000_00_1f_3" "pci_0000_00_1f_4" "pci_0000_00_1f_5")
      failed=false
      for dev in "''${DEVICES[@]}"; do
        if ! sudo virsh nodedev-detach "$dev"; then
          failed=true
        fi
      done
      if [[ "$failed" == true ]]; then
        notify-send "Detach Failed" "Some devices could not be detached" --icon=$HOME/nixo/resources/icons/soundbye.png
        paplay ~/nixo/resources/sfx/error.mp3 & disown
        exit 1
      else
        notify-send "Speakers Detached" --icon=$HOME/nixo/resources/icons/sound-error.png 
      fi
      exit
      ENDX4
      chmod 755 $out/bin/iaudio_deattach
      cat > $out/bin/iaudio_dgpu_windows_vm_start <<'ENDX5'
      ###############################
      #                             #
      #    Dettach the internal     #
      #     Speakers for Dolby      #
      #  experiance in windows and  #
      #        start the VM         #
      #                             #
      ###############################
      #!/run/current-system/sw/bin/bash
      set -x
      set -e
      dettach_safe
      exit_code_dgpu=$?
      if [ $exit_code_dgpu=$? -ne 0 ]; then
          notify-send "Windows Boot aborted" --icon=$HOME/nixo/resources/icons/error.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
          exit 1
      fi
      iaudio_deattach
      exit_code_iaudio=$? 
      if [ $exit_code_iaudio=$? -ne 0 ]; then
          notify-send "Windows Boot aborted: Speakers are under use!" --icon=$HOME/nixo/resources/icons/soundbye.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
          exit 1
      fi
      pkill mpvpaper
      swww img $HOME/nixo/resources/wallpapers/wolf.jpg --transition-step 100 --transition-fps 120 --transition-type grow --transition-angle 30 --transition-duration 1 & disown
      virsh -c qemu:///system start Win11_iAudio
      looking-glass-client -f /dev/kvmfr0 -F & disown
      notify-send "Full Windows VM is Booting UP!" --icon=$HOME/nixo/resources/icons/windows.png
      exit
      ENDX5
      chmod 755 $out/bin/iaudio_dgpu_windows_vm_start
    '';
  };

  fancy_wallpaper_switcher = pkgs.writeShellScriptBin "wallch" ''
    #!/run/current-system/sw/bin/bash

    # Configuration file
    CONFIG_FILE="$HOME/.config/swww-control.conf"

    # Default settings
    WALLPAPER_DIR="$HOME/Pictures"
    INTERVAL=300  # 5 minutes
    TRANSITION="grow"
    TRANSITION_STEP=100
    TRANSITION_FPS=120
    TRANSITION_ANGLE=30
    TRANSITION_DURATION=1

    # Load previous config if exists
    [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

    # Function to save config
    save_config() {
        cat > "$CONFIG_FILE" <<EOF
    WALLPAPER_DIR="$WALLPAPER_DIR"
    INTERVAL=$INTERVAL
    TRANSITION="$TRANSITION"
    TRANSITION_STEP=$TRANSITION_STEP
    TRANSITION_FPS=$TRANSITION_FPS
    TRANSITION_ANGLE=$TRANSITION_ANGLE
    TRANSITION_DURATION=$TRANSITION_DURATION
    EOF
    }

    # Function to get cursor position (Hyprland)
    get_cursor_position() {
        # Get screen size
        screen_info=$(hyprctl monitors -j | jq '.[0]')
        screensizex=$(echo "$screen_info" | jq '.width')
        screensizey=$(echo "$screen_info" | jq '.height')

        # Get cursor position
        cursorposx=$(hyprctl cursorpos -j | jq '.x' 2>/dev/null)
        cursorposy=$(hyprctl cursorpos -j | jq '.y' 2>/dev/null)

        # If getting cursor position fails, default to center
        [[ -z "$cursorposx" ]] && cursorposx=$((screensizex / 2))
        [[ -z "$cursorposy" ]] && cursorposy=$((screensizey / 2))

        # Invert Y-axis for swww transition
        cursorposy_inverted=$((screensizey - cursorposy))
    }

    # Function to change wallpaper with smooth transition
    change_wallpaper() {
        pgrep swww || swww init
        get_cursor_position  # Get cursor position before changing

        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n1)

        if [[ -n "$WALLPAPER" ]]; then
            swww img "$WALLPAPER" --transition-step "$TRANSITION_STEP" --transition-fps "$TRANSITION_FPS" \
                --transition-type "$TRANSITION" --transition-angle "$TRANSITION_ANGLE" --transition-duration "$TRANSITION_DURATION" \
                --transition-pos "$cursorposx, $cursorposy_inverted"
            echo "Wallpaper changed to: $WALLPAPER"
        else
            echo "No wallpapers found in $WALLPAPER_DIR!"
        fi
    }

    # Function to start wallpaper cycling
    start_wallpaper_cycle() {
        stop_wallpaper_cycle
        echo "Starting wallpaper cycle with interval $INTERVAL seconds..."
        nohup bash -c "
            pgrep swww || swww init
            while true; do
                $0 --chgw
                sleep \"$INTERVAL\"
            done
        " > /dev/null 2>&1 & echo $! > "$HOME/.cache/swww-cycle.pid"
    }

    # Function to stop wallpaper cycling
    stop_wallpaper_cycle() {
        if [[ -f "$HOME/.cache/swww-cycle.pid" ]]; then
            kill "$(cat "$HOME/.cache/swww-cycle.pid")" 2>/dev/null && rm "$HOME/.cache/swww-cycle.pid"
            echo "Wallpaper cycle stopped."
        else
            echo "No active wallpaper cycle found."
        fi
    }

    # Function to check status
    check_status() {
        if [[ -f "$HOME/.cache/swww-cycle.pid" ]] && ps -p "$(cat "$HOME/.cache/swww-cycle.pid")" > /dev/null 2>&1; then
            echo "Wallpaper cycle is running (PID: $(cat "$HOME/.cache/swww-cycle.pid"))."
        else
            echo "Wallpaper cycle is not running."
        fi
    }

    # Command handling
    case "$1" in
        --chgw)
            change_wallpaper
            ;;
        --setdir)
            [[ -d "$2" ]] && WALLPAPER_DIR="$2" && save_config && echo "Wallpaper directory set to: $WALLPAPER_DIR"
            ;;
        --setinterval)
            [[ "$2" =~ ^[0-9]+$ ]] && INTERVAL="$2" && save_config && echo "Interval set to: $INTERVAL seconds"
            ;;
        --start)
            start_wallpaper_cycle
            ;;
        --stop)
            stop_wallpaper_cycle
            ;;
        --status)
            check_status
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --chgw               Change wallpaper immediately with effects"
            echo "  --setdir <dir>       Set wallpaper directory"
            echo "  --setinterval <sec>  Set interval for cycling wallpapers"
            echo "  --start              Start wallpaper cycling"
            echo "  --stop               Stop wallpaper cycling"
            echo "  --status             Check if wallpaper cycling is running"
            echo "  --help               Show this help message"
            ;;
        *)
            echo "Invalid command! Use --help for usage."
            ;;
    esac
  '';
  
  nh-go = pkgs.writeScriptBin "nixo" ''
    #!/run/current-system/sw/bin/bash
    
    notifx1 nix_build_start & disown
    sudo tlp ac
    output=$(${pkgs.nh}/bin/nh os switch "$@" 2>&1 | tee /dev/tty)

    if echo "$output" | grep -qi "error"; then
      notifx1 nix_build_failed & disown
      sudo tlp bat
      notify-send "NixOS Rebuild FAILED!" --icon=$HOME/nixo/resources/icons/report.png
    else
      notifx1 nix_build_ok & disown
      sudo tlp bat
      notify-send "NixOS Rebuild SUCESS!" --icon=$HOME/nixo/resources/icons/check.png
    fi
  '';

  ags-go = pkgs.writeScriptBin "agsAction" ''
      #!/run/current-system/sw/bin/bash
      monitor_count=$(hyprctl monitors | grep -c 'Monitor')
      for ((i=0; i<monitor_count; i++)); do
        ags -t "$1""$i"
      done
  '';

in

  {
    security.sudo.extraRules = [

      { users = [ "arsham" ];
        commands = [
        
          {command = "/run/current-system/sw/bin/tlp setcharge 0 0";                                   options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/tlp setcharge 0 1";                                   options = [ "NOPASSWD" ];}
          
          {command = "/run/current-system/sw/bin/tlp bat";                                             options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/tlp ac";                                              options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/tlp-stat -s";                                         options = [ "NOPASSWD" ];}
          
          {command = "/run/current-system/sw/bin/rmmod nvidia_modeset nvidia_uvm nvidia";              options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1"; options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_01_00_0";               options = [ "NOPASSWD" ];}
            
          {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_01_00_0";             options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/rmmod vfio_pci vfio_pci_core vfio_iommu_type1";       options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/modprobe -i nvidia_modeset nvidia_uvm nvidia";        options = [ "NOPASSWD" ];}
          
          {command = "/etc/profiles/per-user/arsham/bin/systemctl stop ollama";                        options = [ "NOPASSWD" ];}
          {command = "/etc/profiles/per-user/arsham/bin/systemctl restart ollama";                     options = [ "NOPASSWD" ];}
  
          {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_00_1f_0";               options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_00_1f_3";               options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_00_1f_4";               options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_00_1f_5";               options = [ "NOPASSWD" ];}
          
          {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_00_1f_0";             options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_00_1f_3";             options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_00_1f_4";             options = [ "NOPASSWD" ];}
          {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_00_1f_5";             options = [ "NOPASSWD" ];}
        
        ]; 
      }
    ];

    environment.systemPackages = with pkgs; [
        dGPU_VFIO
        Windows_VM
        Battery_Related
        fancy_wallpaper_switcher
        nh-go
        ags-go
    ];
  }