#!/run/current-system/sw/bin/bash
set -x

sudo rmmod nvidia_modeset nvidia_uvm nvidia
sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1
sudo virsh nodedev-detach pci_0000_01_00_0