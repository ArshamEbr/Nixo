{ pkgs, pkgs-unstable, config, ... }:
let
dpass = pkgs.stdenv.mkDerivation {
  name = "deattach";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/deattacho.sh <<'EOF'
    #!/run/current-system/sw/bin/bash
    set -x
    sudo rmmod nvidia_modeset nvidia_uvm nvidia
    sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
    sudo virsh nodedev-detach pci_0000_01_00_0
    notify-send "NVIDIA GPU is Detached"
    EOF
    chmod 755 $out/bin/deattacho.sh
  '';
};
dback = pkgs.stdenv.mkDerivation {
  name = "reattach";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/reattacho.sh <<'EOF'
    #!/run/current-system/sw/bin/bash
    set -x
    sudo virsh nodedev-reattach pci_0000_01_00_0
    sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1
    sudo modprobe -i nvidia_modeset nvidia_uvm nvidia
    notify-send "NVIDIA GPU is Reattached"
    EOF
    chmod 755 $out/bin/reattacho.sh
  '';
};
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
      notify-send "NVIDIA GPU is Passed Through"
    else
      # Check if the NVIDIA driver is in use
      nvidia_status=$(lspci -nnk -d 10de:1c94 | grep -i 'Kernel driver in use' | grep -i 'nvidia')
      if [[ -n "$nvidia_status" ]]; then
        notify-send "NVIDIA GPU is Under Control"
      else
        notify-send "NVIDIA GPU is in an Unknown State"
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
in
{
    environment.systemPackages = with pkgs; [
      dpass
      dback
      battery_toggle
      battery_percentage
      check_gpu_status
    ]
}