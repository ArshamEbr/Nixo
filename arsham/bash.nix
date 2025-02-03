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
    # Check if the GPU is using the VFIO driver
    vfio_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'vfio-pci')
    if [[ -n "$vfio_status" ]]; then
      notify-send "NVIDIA dGPU is Passed Through"
    else
      # Check if the NVIDIA driver is in use
      nvidia_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'nvidia')
      if [[ -n "$nvidia_status" ]]; then
        notify-send "NVIDIA dGPU is Under Control"
      else
        notify-send "NVIDIA dGPU is in an Unknown State"
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
      # If battery conservation mode is ON, turn it OFF
      sudo tlp setcharge 0 0
      notify-send "Battery Conservation Mode OFF"
    else
      # Otherwise, turn it ON
      sudo tlp setcharge 0 1
      notify-send "Battery Conservation Mode ON"
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
    
    # Device identification: NVIDIA GPU with PCI ID 10de:1c94.
    # Check current driver using lspci. If it's already using vfio-pci, assume it is detached.
    driver=$(lspci -nnk -d 10de:1c94 | grep "Kernel driver in use" | awk -F': ' '{print $2}')
    if [[ "$driver" == "vfio-pci" ]]; then
      notify-send "NVIDIA dGPU is Already Detached"
      echo "NVIDIA dGPU is already detached"
      exit 0
    fi
    
    # Check for running GPU processes via nvidia-smi.
    pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader | xargs)
    if [ -n "$pids" ]; then
      sudo systemctl stop ollama
      notify-send "dGPU Dettach Aborted Cuz it's under use!"
      echo "dGPU detach aborted: processes running: $pids"
      exit 1
    fi
    
    # Proceed to detach the GPU.
    sudo systemctl stop ollama
    sudo rmmod nvidia_modeset nvidia_uvm nvidia
    sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
    sudo virsh nodedev-detach pci_0000_01_00_0
    notify-send "NVIDIA dGPU is Detached"
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
    
    # Check current driver for the NVIDIA GPU using its PCI ID (10de:1c94)
    driver=$(lspci -nnk -d 10de:1c94 | grep "Kernel driver in use" | awk -F': ' '{print $2}')
    
    if [[ "$driver" == "nvidia" ]]; then
      notify-send "NVIDIA dGPU is already attached"
      echo "NVIDIA dGPU is already attached"
      exit 0
    fi
    
    # Proceed to reattach the GPU
    sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1
    sudo virsh nodedev-reattach pci_0000_01_00_0
    sudo modprobe -i nvidia_modeset nvidia_uvm nvidia
    notify-send "NVIDIA dGPU is Reattached"
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
    
    # Run the detach script and capture its exit code.
    dettach_safe.sh
    exit_code=$?
    
    # If dettach_safe.sh was aborted, exit and notify.
    if [ $exit_code -ne 0 ]; then
        notify-send "Windows Boot aborted: dGPU is under use!"
        echo "GPU detach aborted: GPU is under use."
        exit 1
    fi
    
    # Continue with launching the Windows VM if detach succeeded.
    pkill mpvpaper
    swaybg -i /home/arsham/Wallpapers/mitsu.png & disown
    virsh -c qemu:///system start Win11
    looking-glass-client -F & disown
    notify-send "Windows VM is Booting UP!"
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
    
    # Kill swaybg process.
    pkill swaybg
    
    # Restart mpvpaper if needed (only if it's not already running)
    pgrep mpvpaper > /dev/null || mpvpaper '*' ~/Wallpapers/mitsu.mp4 -o '--loop-file=yes' & disown
    
    # Request the Windows VM to shutdown.
    virsh -c qemu:///system shutdown Win11
    notify-send "Shutdown initiated for Windows VM"
    
    # Wait until the VM is completely shut off.
    # We'll check for the state "shut off" (not just "not running") and
    # use a maximum wait time to avoid hanging indefinitely.
    max_wait=7  # maximum wait time in seconds
    waited=0
    while true; do
        state=$(virsh -c qemu:///system domstate Win11 2>/dev/null)
        echo "Current VM state: $state"
        if [[ "$state" == "shut off" ]]; then
            break
        fi
        sleep 2
        waited=$((waited+2))
        if (( waited >= max_wait )); then
            notify-send "Timeout waiting for Windows VM to shut down. GPU reattach aborted."
            echo "Timeout waiting for Windows VM to shut down. Aborting reattach."
            exit 1
        fi
    done
    
    pkill -f looking-glass-client
    
    notify-send "Windows VM is completely shutdown!"
    
    reattach_safe.sh & disown
    exit
    EOF
    chmod 755 $out/bin/dgpu_windows_vm_shutdown.sh
  '';
};
in
{
  security.sudo.extraRules = [

    { users = [ "arsham" ];
      commands = [

        {command = "/run/current-system/sw/bin/tlp setcharge 0 0";                                   options = [ "NOPASSWD" ];}
        {command = "/run/current-system/sw/bin/tlp setcharge 0 1";                                   options = [ "NOPASSWD" ];}
         
        {command = "/run/current-system/sw/bin/rmmod nvidia_modeset nvidia_uvm nvidia";              options = [ "NOPASSWD" ];}
        {command = "/run/current-system/sw/bin/modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1"; options = [ "NOPASSWD" ];}
        {command = "/run/current-system/sw/bin/virsh nodedev-detach pci_0000_01_00_0";               options = [ "NOPASSWD" ];}
          
        {command = "/run/current-system/sw/bin/virsh nodedev-reattach pci_0000_01_00_0";             options = [ "NOPASSWD" ];}
        {command = "/run/current-system/sw/bin/rmmod vfio_pci vfio_pci_core vfio_iommu_type1";       options = [ "NOPASSWD" ];}
        {command = "/run/current-system/sw/bin/modprobe -i nvidia_modeset nvidia_uvm nvidia";        options = [ "NOPASSWD" ];}
        
        {command = "/etc/profiles/per-user/arsham/bin/systemctl stop ollama";                        options = [ "NOPASSWD" ];}
        {command = "/etc/profiles/per-user/arsham/bin/systemctl restart ollama";                     options = [ "NOPASSWD" ];}
        
      ]; 
    }
  ];

  environment.systemPackages = with pkgs; [
      dgpu_windows_vm_shutdown
      dgpu_windows_vm_start
      dgpu_pass_safe
      dgpu_back_safe
      battery_toggle
      battery_percentage
      check_gpu_status
  ];
}