#!/bin/bash
# Based on https://github.com/joeknock90/Single-GPU-Passthrough

set -x

source "/etc/libvirt/hooks/kvm.conf"

# Unload VFIO kernel modules
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Reattach GPU IOMMU group
virsh nodedev-reattach $VIRSH_GPU_PCI_BRIDGE
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_USB
virsh nodedev-reattach $VIRSH_GPU_SERIAL

# Reattach USB controller IOMMU groups
virsh nodedev-reattach $VIRSH_CPU_SRAM
virsh nodedev-reattach $VIRSH_CPU_USB
virsh nodedev-reattach $VIRSH_CPU_THUNDERBOLT

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload nvidia kernel modules
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia
modprobe drm
modprobe nvidia_uvm

systemctl restart lightdm-plymouth
