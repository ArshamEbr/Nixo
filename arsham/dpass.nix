{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "detach-vfio";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/detach-vfio.sh <<'EOF'
    #!/run/current-system/sw/bin/bash
    set -x

    sudo rmmod nvidia_modeset nvidia_uvm nvidia
    sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
    sudo virsh nodedev-detach pci_0000_01_00_0
    EOF
    chmod 755 $out/bin/detach-vfio.sh
  '';
}