#!/nix/store/p6k7xp1lsfmbdd731mlglrdj2d66mr82-bash-5.2p37/bin/bash
set -x

sudo virsh nodedev-reattach pci_0000_01_00_0
sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1
sudo modprobe -i nvidia_modeset nvidia_uvm nvidia
