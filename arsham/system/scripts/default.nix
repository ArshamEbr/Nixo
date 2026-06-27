{ 
  pkgs, 
  user, 
  ... 
}:

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
      #!/usr/bin/env bash
      # Hardware ID for your dGPU (GTX 1060 Mobile?)
      GPU_ID="10de:1c94"
      driver_info=$(lspci -nnk -d "$GPU_ID" | grep -i "Kernel driver in use")
      if [[ "$driver_info" == *"vfio-pci"* ]]; then
        notify-send "dGPU Status" "NVIDIA dGPU is Passed Through" --icon="$HOME/nixo/resources/icons/nvidia.png"
        notifx1 detached
      elif [[ "$driver_info" == *"nvidia"* ]]; then
        notify-send "dGPU Status" "NVIDIA dGPU is Under Control" --icon="$HOME/nixo/resources/icons/lgpu.png"
        notifx1 vfio_off
      else
        notify-send "dGPU Status" "NVIDIA dGPU is in an Unknown State" --icon="$HOME/nixo/resources/icons/report.png"
        notifx1 warn
      fi
      ENDX1
      chmod 755 $out/bin/check_gpu_status
      cat > $out/bin/detach_safe <<'ENDX2'
      ############################
      #                          #
      #    Detach dGPU Safely    #
      #                          #
      ############################
      #!/usr/bin/env bash
      
      GPU_ID="10de:1c94"
      driver=$(lspci -nnk -d "$GPU_ID" | grep "Kernel driver in use" | awk -F': ' '{print $2}')
      if [[ "$driver" == "vfio-pci" ]]; then
        notify-send "Status" "NVIDIA dGPU is Already Detached" --icon="$HOME/nixo/resources/icons/gpu.png"
        notifx1 detached
        exit 0
      fi
      if [[ "$driver" != "nvidia" ]]; then
        notify-send "Error" "dGPU is in an unknown state (Driver: $driver)" --icon="$HOME/nixo/resources/icons/report.png"
        notifx1 warn
        exit 1
      fi
      nvidia_processes=$(lsof /dev/nvidia* 2>/dev/null | awk 'NR>1 {print $1, $2}' | sort -u)
      if [ -n "$nvidia_processes" ]; then
        notify-send -t 10000 "Abort" "Processes are using the dGPU:\n$nvidia_processes" --icon="$HOME/nixo/resources/icons/warning.png"
        notifx1 warn
        echo "Abort: Processes using /dev/nvidia0:"
        echo "$nvidia_processes"
        exit 1
      fi
      pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader 2>/dev/null | xargs)
      if [ -n "$pids" ]; then
        notify-send -t 10000 "Abort" "Compute processes running:\n$pids" --icon="$HOME/nixo/resources/icons/warning.png"
        notifx1 warn
        echo "Abort: Compute processes running: $pids"
        exit 1
      fi
      echo "Unloading NVIDIA drivers..."
      sudo ${pkgs.kmod}/bin/rmmod nvidia_modeset nvidia_uvm nvidia
      echo "Loading VFIO modules..."
      sudo ${pkgs.kmod}/bin/modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 
      echo "Detaching PCI device..."
      sudo ${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0
      notify-send "Success" "NVIDIA dGPU is Detached" --icon="$HOME/nixo/resources/icons/nvidia.png"
      notifx1 detached
      ENDX2
      chmod 755 $out/bin/detach_safe
      cat > $out/bin/reattach_safe <<'ENDX3'
      ############################
      #                          #
      #   Reattach dGPU Safely   #
      #                          #
      ############################
      #!/usr/bin/env bash
      GPU_ID="10de:1c94"
      driver=$(lspci -nnk -d "$GPU_ID" | grep "Kernel driver in use" | awk -F': ' '{print $2}')
      if [[ "$driver" == "nvidia" ]]; then
        notify-send "Status" "NVIDIA dGPU is already attached" --icon="$HOME/nixo/resources/icons/lgpu.png"
        notifx1 notif
        exit 0
      fi
      if [[ "$driver" != "vfio-pci" ]]; then
        notify-send "Error" "dGPU is in an unknown state (Driver: $driver). Cannot reattach." --icon="$HOME/nixo/resources/icons/report.png"
        notifx1 warn
        exit 1
      fi
      echo "Ensuring kvmfr is loaded..."
      sudo ${pkgs.kmod}/bin/modprobe kvmfr static_size_mb=64
      echo "Unloading VFIO modules..."
      sudo ${pkgs.kmod}/bin/rmmod vfio_pci vfio_pci_core vfio_iommu_type1
      echo "Reattaching PCI device to Host..."
      sudo ${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0
      echo "Loading NVIDIA drivers..."
      sudo ${pkgs.kmod}/bin/modprobe -i nvidia_modeset nvidia_uvm nvidia
      notify-send "Success" "NVIDIA dGPU is Reattached" --icon="$HOME/nixo/resources/icons/nvidia.png"
      notifx1 reattached
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
      #!/usr/bin/env bash
      set -x
  
      # Function to turn conservation mode on
      conserve_on() {
        sudo ${pkgs.tlp}/bin/tlp setcharge 0 1
        notifx1 conserve_on & disown
        notify-send "Battery Conservation Mode ON" --icon=$HOME/nixo/resources/icons/conserve_on.png
      }
  
      # Function to turn conservation mode off
      conserve_off() {
        sudo ${pkgs.tlp}/bin/tlp setcharge 0 0
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
      #!/usr/bin/env bash
      set -x
      current_mode=$(${pkgs.tlp}/bin/tlp-stat -s | grep "Mode" | awk '{print $3}')
      if [[ "$current_mode" == "battery" ]]; then
          new_mode="ac"
          mode_name="Maximum Performance"
          notifx1 max_pwr & disown
          icon=$HOME/nixo/resources/icons/performance.png
      else
          new_mode="bat"
          mode_name="Maximum Power Saving"
          notifx1 max_save & disown
          icon=$HOME/nixo/resources/icons/power_saving.png
      fi
      sudo ${pkgs.tlp}/bin/tlp "$new_mode"
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
      #!/usr/bin/env bash
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
      #!/usr/bin/env bash
      if ! detach_safe; then
          notify-send "Boot Error" "GPU Detach failed! Windows Boot aborted." --icon="$HOME/nixo/resources/icons/error.png"
          notifx1 error
          exit 1
      fi
      vm_name="Win10"
      state=$(${pkgs.libvirt}/bin/virsh -c qemu:///system domstate "$vm_name" 2>/dev/null)
      if [[ "$state" == "running" ]]; then
          notify-send "Status" "Windows VM is already running." --icon="$HOME/nixo/resources/icons/windows.png"
          looking-glass-client -F & disown
          exit 0
      fi
      pkill mpvpaper
      pkill swaybg
      echo "Starting $vm_name..."
      ${pkgs.libvirt}/bin/virsh -c qemu:///system start "$vm_name"
      looking-glass-client -F & disown
      notify-send "VM Manager" "Windows VM is Booting UP!" --icon="$HOME/nixo/resources/icons/windows.png"
      notifx1 windows_on
      ENDX1
      chmod 755 $out/bin/dgpu_windows_vm_start
      cat > $out/bin/dgpu_windows_vm_shutdown <<'ENDX2'
      ###############################
      #                             #
      #   Shutdown the windows VM   #
      #    and reattach the dGPU    #
      #                             #
      ###############################
      #!/usr/bin/env bash
      VM1="Win10"
      VM2="Win10_iAudio"
      MAX_WAIT=10
      state_win10=$(${pkgs.libvirt}/bin/virsh -c qemu:///system domstate "$VM1" 2>/dev/null)
      state_audio=$(${pkgs.libvirt}/bin/virsh -c qemu:///system domstate "$VM2" 2>/dev/null)
      if [[ "$state_win10" == "shut off" && "$state_audio" == "shut off" ]]; then
          notify-send "VM Manager" "VMs are already off. Aborting shutdown sequence." --icon="$HOME/nixo/resources/icons/shutdown.png"
          exit 0
      fi
      # pkill swaybg
      # pkill -f mpvpaper 
      safe_shutdown() {
        local vm="$1"
        local state="$2"
        if [[ "$state" == "running" ]]; then
          echo "Shutting down $vm..."
          ${pkgs.libvirt}/bin/virsh -c qemu:///system shutdown "$vm" > /dev/null
        elif [[ "$state" == "shut off" ]]; then
          echo "$vm is already off."
        else
          echo "$vm is in state: $state (skipping)"
        fi
      }
      safe_shutdown "$VM1" "$state_win10"
      safe_shutdown "$VM2" "$state_audio"
      notify-send "VM Manager" "Shutting down Windows VMs..." --icon="$HOME/nixo/resources/icons/close.png"
      waited=0
      while true; do
          state_win10=$(${pkgs.libvirt}/bin/virsh -c qemu:///system domstate "$VM1" 2>/dev/null)
          state_audio=$(${pkgs.libvirt}/bin/virsh -c qemu:///system domstate "$VM2" 2>/dev/null)
          if [[ "$state_win10" == "shut off" && "$state_audio" == "shut off" ]]; then
              echo "All VMs shut down successfully."
              break
          fi    
          sleep 2
          waited=$((waited+2))     
          if (( waited >= MAX_WAIT )); then
              notify-send "Timeout" "Windows VM took too long to shut down." --icon="$HOME/nixo/resources/icons/report.png"
              notifx1 error &
              exit 1
          fi
      done
      pkill -f looking-glass-client 
      notify-send "VM Manager" "Windows VMs completely shutdown!" --icon="$HOME/nixo/resources/icons/shutdown.png"
      notifx1 windows_off &
      reattach_safe & 
      iaudio_reattach &
      exit 0
      ENDX2
      chmod 755 $out/bin/dgpu_windows_vm_shutdown
      cat > $out/bin/iaudio_reattach <<'ENDX3'
      ###############################
      #                             #
      #   Reattach the internal     #
      #          Speakers           #
      #                             #
      ###############################
      #!/usr/bin/env bash 
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
        if ! sudo ${pkgs.libvirt}/bin/virsh nodedev-reattach "$dev"; then
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
      #!/usr/bin/env bash
      set -x
      driver=$(lspci -nnk -d 8086:a0c8 | grep "Kernel driver in use" | awk -F': ' '{print $2}') 
      if [[ "$driver" == "vfio-pci" ]]; then
        notify-send "Speakers already detached" --icon=$HOME/nixo/resources/icons/sound.png
        exit 0
      fi
      DEVICES=("pci_0000_00_1f_0" "pci_0000_00_1f_3" "pci_0000_00_1f_4" "pci_0000_00_1f_5")
      failed=false
      for dev in "''${DEVICES[@]}"; do
        if ! sudo ${pkgs.libvirt}/bin/virsh nodedev-detach "$dev"; then
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
      #!/usr/bin/env bash
      set -x
      set -e
      detach_safe
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
      ${pkgs.libvirt}/bin/virsh -c qemu:///system start Win10_iAudio
      sudo ${pkgs.coreutils}/bin/chown ${user.name}:qemu-libvirtd /dev/kvmfr0
      looking-glass-client -f /dev/kvmfr0 -F & disown
      notify-send "Full Windows VM is Booting UP!" --icon=$HOME/nixo/resources/icons/windows.png
      exit
      ENDX5
      chmod 755 $out/bin/iaudio_dgpu_windows_vm_start
    '';
  };

  fancy_wallpaper_switcher = pkgs.writeShellScriptBin "wallch" ''
    #!/usr/bin/env bash

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
    #!/usr/bin/env bash
    
    tlp_mode() {
      sudo ${pkgs.tlp}/bin/tlp "$1"
    }
    
    check_battery_conservation() {
      if [ -f /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode ]; then
        cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
      else
        echo "0"  # Default to off if file doesn't exist
      fi
    }

    restore_battery_conservation() {
      if [ "$1" = "1" ]; then
        sudo ${pkgs.tlp}/bin/tlp setcharge 0 1
        echo "Battery conservation mode restored"
      fi
    }
    
    initial_conservation_state=$(check_battery_conservation)
    notifx1 nix_build_start & disown
    tlp_mode ac
    output=$(${pkgs.nh}/bin/nh os switch "$@" 2>&1 | tee /dev/tty)
    nh_status=$?
    
    if [ $nh_status -ne 0 ]; then
      notifx1 nix_build_failed & disown
      tlp_mode start
      restore_battery_conservation "$initial_conservation_state"
      notify-send "NixOS Rebuild FAILED!" --icon=$HOME/nixo/resources/icons/report.png
    else
      notifx1 nix_build_ok & disown
      tlp_mode start
      restore_battery_conservation "$initial_conservation_state"
      notify-send "NixOS Rebuild SUCCESS!" --icon=$HOME/nixo/resources/icons/check.png
    fi
  '';

  way-net-go = pkgs.writeScriptBin "way_network" ''
    #!/usr/bin/env bash
    # Change to your network interface
    INTERFACE="wlan0"
    
    # Get total bytes since boot/interface-up
    RX_TOTAL=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_TOTAL=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    
    # Convert to MB or GB
    rx_total_mb=$((RX_TOTAL / 1024 / 1024))
    tx_total_mb=$((TX_TOTAL / 1024 / 1024))

    total_dw=$((rx_total_mb + tx_total_mb))
    
    # For speed measurement
    RX_PREV=$RX_TOTAL
    TX_PREV=$TX_TOTAL
    sleep 1
    RX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_NEXT=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    
    # Speed in KB/s
    RX_RATE=$(( (RX_NEXT - RX_PREV) / 1024 ))
    TX_RATE=$(( (TX_NEXT - TX_PREV) / 1024 ))

    echo -n " $RX_RATE KB/s |  $TX_RATE KB/s | $total_dw MB ↑↓"
  '';

  record-scripto = pkgs.writeScriptBin "record-script" ''
    #!/usr/bin/env bash

    getdate() {
        date '+%Y-%m-%d_%H.%M.%S'
    }
    getaudiooutput() {
        pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
    }
    getactivemonitor() {
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
    }
    
    mkdir -p "$(xdg-user-dir VIDEOS)"
    cd "$(xdg-user-dir VIDEOS)" || exit
    if pgrep wf-recorder > /dev/null; then
        notify-send "Recording Stopped" "Stopped" -a 'record-script.sh' &
        pkill wf-recorder &
    else
        notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'record-script.sh'
        if [[ "$1" == "--sound" ]]; then
            wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(slurp)" --audio="$(getaudiooutput)" & disown
        elif [[ "$1" == "--fullscreen-sound" ]]; then
            wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --audio="$(getaudiooutput)" & disown
        elif [[ "$1" == "--fullscreen" ]]; then
            wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t & disown
        else
            wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(slurp)" & disown
        fi
    fi
  '';

  waybar-cava = pkgs.stdenv.mkDerivation {
    name = "waybar-cava";
    src = ../resources/scripts/WaybarCava.sh;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/waybar_cava
      chmod +x $out/bin/waybar_cava
    '';
  };

  gpu-info = pkgs.stdenv.mkDerivation {
    name = "gpu-info";
    src = ../../../resources/scripts/gpuinfo.sh;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/gpuinfo
      chmod +x $out/bin/gpuinfo
    '';
  };

  way-neto = pkgs.stdenv.mkDerivation {
    name = "way-neto";
    src = ../../../resources/scripts/waynet.sh;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/waynet
      chmod +x $out/bin/waynet
    '';
  };

  odin4 = pkgs.stdenv.mkDerivation {
    name = "odin4";
    src = ../../../resources/bin/odin4;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/odin
      chmod +x $out/bin/odin
    '';
  };

  mi-thermal-crypt = pkgs.stdenv.mkDerivation {
    name = "mi-thermal-crypt";
    src = ../../../resources/bin/mi-thermal-crypt;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/mi-thermal-crypt
      chmod +x $out/bin/mi-thermal-crypt
    '';
  };

  yin = pkgs.stdenv.mkDerivation {
    name = "yin";
    src = ../../../resources/bin;
    
    # Runtime dependencies
    buildInputs = with pkgs; [
      wayland
      pixman
      lz4
      ffmpeg
    ];
    
    phases = [ "installPhase" "fixupPhase" ];
    
    installPhase = ''
      mkdir -p $out/bin
      cp $src/yin $out/bin/yin
      cp $src/yinctl $out/bin/yinctl
      chmod +x $out/bin/yin
      chmod +x $out/bin/yinctl
    '';
    
    dontStrip = true;
  };

  power-go = pkgs.writeScriptBin "power-save" ''
    #!/usr/bin/env bash
    if hyprctl getoption animations:enabled | grep -q 'int: 1'; then
      hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword windowrulev2 opacity 1 1,class:.*;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    else
      hyprctl reload
    fi
  '';

  wall-aware = pkgs.writeScriptBin "wall-aware" ''
    #!/usr/bin/env bash
    
    VIDEO_PATH="/home/arsham/nixo/resources/wallpapers/mitsu.mp4"
    IMAGE_PATH="/home/arsham/nixo/resources/wallpapers/mitsu.png"
    
    swww_to_mpvpaper() {
      mpvpaper '*' "$VIDEO_PATH" -o "--loop-file=yes" &
      sleep 1
      pkill -x swww-daemon 2>/dev/null || true
    }
    
    mpvpaper_to_swww() {
      swww-daemon &
      sleep 1
      swww img "$IMAGE_PATH"
      pkill -x mpvpaper 2>/dev/null || true
    }
    
    case "$1" in
      to_mpv)
        swww_to_mpvpaper
        ;;
      to_swww)
        mpvpaper_to_swww
        ;;
      *)
        echo "Usage: $0 {to_mpv|to_swww}"
        ;;
    esac
  '';

  chownKvmfr = pkgs.writeShellScriptBin "chown-kvmfr0" ''
    #!/usr/bin/env bash
    ${pkgs.coreutils}/bin/chown ${user.name}:qemu-libvirtd /dev/kvmfr0
  '';

in

  {
    security.sudo.extraRules = [
      { users = [ "${user.name}" ];
        commands = [
        
          {command = "${pkgs.tlp}/bin/tlp setcharge 0 0";                                    options = [ "NOPASSWD" ];}
          {command = "${pkgs.tlp}/bin/tlp setcharge 0 1";                                    options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.tlp}/bin/tlp bat";                                              options = [ "NOPASSWD" ];}
          {command = "${pkgs.tlp}/bin/tlp ac";                                               options = [ "NOPASSWD" ];}
          {command = "${pkgs.tlp}/bin/tlp start";                                            options = [ "NOPASSWD" ];}
          {command = "${pkgs.tlp}/bin/tlp-stat -s";                                          options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.kmod}/bin/rmmod nvidia_modeset nvidia_uvm nvidia";              options = [ "NOPASSWD" ];}
          {command = "${pkgs.kmod}/bin/modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1"; options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_01_00_0";            options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_01_00_0";          options = [ "NOPASSWD" ];}
          {command = "${pkgs.kmod}/bin/rmmod vfio_pci vfio_pci_core vfio_iommu_type1";       options = [ "NOPASSWD" ];}
          {command = "${pkgs.kmod}/bin/modprobe -i nvidia_modeset nvidia_uvm nvidia";        options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_00_1f_0";            options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_00_1f_3";            options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_00_1f_4";            options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-detach pci_0000_00_1f_5";            options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_00_1f_0";          options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_00_1f_3";          options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_00_1f_4";          options = [ "NOPASSWD" ];}
          {command = "${pkgs.libvirt}/bin/virsh nodedev-reattach pci_0000_00_1f_5";          options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.kmod}/bin/modprobe kvmfr static_size_mb=64";                    options = [ "NOPASSWD" ];}
          
          {command = "${pkgs.coreutils}/bin/chown ${user.name}\\:qemu-libvirtd /dev/kvmfr0"; options = [ "NOPASSWD" ];}
        
        ]; 
      }
    ];

  #  imports = [
  #    ./wallpaperService.nix
  #  ];

    environment.systemPackages = with pkgs; [
        dGPU_VFIO
        Windows_VM
        Battery_Related
        fancy_wallpaper_switcher
      #  wall-aware
        nh-go
      #  way-net-go
        way-neto
        record-scripto
      #  waybar-cava
        gpu-info
        chownKvmfr
        power-go
        odin4
        mi-thermal-crypt
        yin
    ];
  }