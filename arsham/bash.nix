{ pkgs, pkgs-unstable, config, ... }:
let

  check_gpu_status = pkgs.stdenv.mkDerivation {
    name = "check_gpu_status";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/check_gpu_status.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      vfio_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'vfio-pci')
      if [[ -n "$vfio_status" ]]; then
        notify-send "NVIDIA dGPU is Passed Through" --icon=$HOME/nixo/resources/icons/nvidia.png
        paplay ~/nixo/resources/sfx/dgpu_pass.mp3 & disown
      else
        nvidia_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'nvidia')
        if [[ -n "$nvidia_status" ]]; then
          notify-send "NVIDIA dGPU is Under Control" --icon=$HOME/nixo/resources/icons/lgpu.png
          paplay ~/nixo/resources/sfx/dgpu_back.mp3 & disown
        else
          notify-send "NVIDIA dGPU is in an Unknown State" --icon=$HOME/nixo/resources/icons/report.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
        fi
      fi
      EOF
      chmod 755 $out/bin/check_gpu_status.sh
    '';
  };
  
  battery_toggle = pkgs.stdenv.mkDerivation {
    name = "battery_toggle";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/battery_toggle.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      # Check current conservation_mode state
      current_state=$(cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode)
      if [[ "$current_state" == "1" ]]; then
        sudo tlp setcharge 0 0
        paplay ~/nixo/resources/sfx/battery_conserve_off.mp3 & disown
        notify-send "Battery Conservation Mode OFF" --icon=$HOME/nixo/resources/icons/conserve_off.png
      else
        sudo tlp setcharge 0 1
        paplay ~/nixo/resources/sfx/battery_conserve_on.mp3 & disown
        notify-send "Battery Conservation Mode ON" --icon=$HOME/nixo/resources/icons/conserve_on.png
      fi
      EOF
      chmod 755 $out/bin/battery_toggle.sh
    '';
  };
  
  battery_percentage = pkgs.stdenv.mkDerivation {
    name = "battery_percent";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/battery_percent.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      #!/run/current-system/sw/bin/bash
      ############ Variables ############
      enable_battery=false
      battery_charging=false
      
      ####### Check availability ########
      for battery in /sys/class/power_supply/*BAT*; do
        if [[ -f "$battery/uevent" ]]; then
          enable_battery=true
          if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
            battery_charging=true
          fi
          break
        fi
      done
      
      ############# Output #############
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
      EOF
      chmod 755 $out/bin/battery_percent.sh
    '';
  };
  
  dgpu_pass_safe = pkgs.stdenv.mkDerivation {
    name = "dettach_safe";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/dettach_safe.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      driver=$(lspci -nnk -d 10de:1c94 | grep "Kernel driver in use" | awk -F': ' '{print $2}')
      if [[ "$driver" == "vfio-pci" ]]; then
        notify-send "NVIDIA dGPU is Already Detached" --icon=$HOME/nixo/resources/icons/gpu.png
        paplay ~/nixo/resources/sfx/notif.mp3 & disown
        exit 0
      fi
      pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader | xargs)
      if [ -n "$pids" ]; then
        sudo systemctl stop ollama
        notify-send "dGPU Dettach Aborted Cuz it's under use!" --icon=$HOME/nixo/resources/icons/warning.png
        paplay ~/nixo/resources/sfx/error.mp3 & disown
        echo "dGPU detach aborted: processes running: $pids"
        exit 1
      fi
      sudo systemctl stop ollama
      sudo rmmod nvidia_modeset nvidia_uvm nvidia
      sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
      sudo virsh nodedev-detach pci_0000_01_00_0
      notify-send "NVIDIA dGPU is Detached" --icon=$HOME/nixo/resources/icons/nvidia.png
      paplay ~/nixo/resources/sfx/detach.mp3 & disown
      exit
      EOF
          chmod 755 $out/bin/dettach_safe.sh
    '';
  };
  
  dgpu_back_safe = pkgs.stdenv.mkDerivation {
    name = "reattach_safe";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/reattach_safe.sh <<'EOF'
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
      EOF
      chmod 755 $out/bin/reattach_safe.sh
    '';
  };
  
  dgpu_windows_vm_start = pkgs.stdenv.mkDerivation {
    name = "dgpu_windows_vm_start";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/dgpu_windows_vm_start.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      dettach_safe.sh
      exit_code=$?
      if [ $exit_code -ne 0 ]; then
          notify-send "Windows Boot aborted: dGPU is under use!" --icon=$HOME/nixo/resources/icons/error.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
          exit 1
      fi
      pkill mpvpaper
      swaybg -i /home/arsham/Wallpapers/mitsu.png & disown
      virsh -c qemu:///system start Win11
      looking-glass-client -F & disown
      notify-send "Windows VM is Booting UP!" --icon=$HOME/nixo/resources/icons/windows.png
      paplay ~/nixo/resources/sfx/windows_on.mp3 & disown
      exit
      EOF
      chmod 755 $out/bin/dgpu_windows_vm_start.sh
    '';
  };
  
  dgpu_windows_vm_shutdown = pkgs.stdenv.mkDerivation {
    name = "dgpu_windows_vm_shutdown";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/dgpu_windows_vm_shutdown.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      pkill swaybg
      pgrep mpvpaper > /dev/null || mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes' & disown
      virsh -c qemu:///system shutdown Win11 
      virsh -c qemu:///system shutdown Win11_iAudio
      notify-send "Shutdown initiated for Windows VM" --icon=$HOME/nixo/resources/icons/close.png
      max_wait=8
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
      reattach_safe.sh & disown
      iaudio_reattach.sh & disown
      exit
      EOF
      chmod 755 $out/bin/dgpu_windows_vm_shutdown.sh
    '';
  };

  tlp_mode = pkgs.stdenv.mkDerivation {
  name = "tlp_mode";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/tlp_mode.sh <<'EOF'
    #!/run/current-system/sw/bin/bash
    set -x
    current_mode=$(tlp-stat -s | grep "Mode" | awk '{print $3}')
    if [[ "$current_mode" == "battery" ]]; then
        new_mode="ac"
        mode_name="Maximum Performance"
        sound_file=~/nixo/resources/sfx/performance.mp3
        icon=$HOME/nixo/resources/icons/performance.png
    else
        new_mode="bat"
        mode_name="Maximum Power Saving"
        sound_file=~/nixo/resources/sfx/power_saving.mp3
        icon=$HOME/nixo/resources/icons/power_saving.png
    fi
    sudo tlp "$new_mode"
    paplay $sound_file & disown
    notify-send "Power Mode Switched!" "Now in $mode_name mode" --icon=$icon
    EOF
    chmod 755 $out/bin/tlp_mode.sh
  '';
  };

  iaudio_back = pkgs.stdenv.mkDerivation {
    name = "iaudio_reattach";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/iaudio_reattach.sh <<'EOF'
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
      EOF
      chmod 755 $out/bin/iaudio_reattach.sh
    '';
  };
   
  iaudio_pass = pkgs.stdenv.mkDerivation {
   name = "iaudio_deattach";
   phases = [ "installPhase" ];
   installPhase = ''
     mkdir -p $out/bin
     cat > $out/bin/iaudio_deattach.sh <<'EOF'
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
     EOF
     chmod 755 $out/bin/iaudio_deattach.sh
   '';
  };

  iaudio_dgpu_windows_vm_start = pkgs.stdenv.mkDerivation {
    name = "iaudio_dgpu_windows_vm_start";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/iaudio_dgpu_windows_vm_start.sh <<'EOF'
      #!/run/current-system/sw/bin/bash
      set -x
      dettach_safe.sh
      exit_code_dgpu=$?
      iaudio_deattach.sh
      exit_code_iaudio=$? 
      if [ $exit_code_dgpu=$? -ne 0 ]; then
          notify-send "Windows Boot aborted: dGPU is under use!" --icon=$HOME/nixo/resources/icons/error.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
          exit 1
      fi
      if [ $exit_code_iaudio=$? -ne 0 ]; then
          notify-send "Windows Boot aborted: Speakers are under use!" --icon=$HOME/nixo/resources/icons/soundbye.png
          paplay ~/nixo/resources/sfx/error.mp3 & disown
          exit 1
      fi
      pkill mpvpaper
      swaybg -i /home/arsham/Wallpapers/mitsu.png & disown
      virsh -c qemu:///system start Win11_iAudio
      looking-glass-client -F & disown
      notify-send "Full Windows VM is Booting UP!" --icon=$HOME/nixo/resources/icons/windows.png
      exit
      EOF
      chmod 755 $out/bin/iaudio_dgpu_windows_vm_start.sh
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
         dgpu_windows_vm_shutdown
         dgpu_windows_vm_start
         iaudio_dgpu_windows_vm_start
         iaudio_back
         iaudio_pass
         dgpu_pass_safe
         dgpu_back_safe
         battery_toggle
         battery_percentage
         check_gpu_status
         tlp_mode
         fancy_wallpaper_switcher
     ];
  }