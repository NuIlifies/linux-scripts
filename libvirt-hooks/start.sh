#!/bin/bash
# Based on https://github.com/joeknock90/Single-GPU-Passthrough

set -x
source "/etc/libvirt/hooks/kvm.conf"

systemctl stop lightdm-plymouth

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 4

# Unload nvidia kernel modules
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu
modprobe -r drm
modprobe -r nvidia_uvm

# Detach dGPU IOMMU group
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_PCI_BRIDGE
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_GPU_USB
virsh nodedev-detach $VIRSH_GPU_SERIAL

# Detach Intel USB controller IOMMU group
virsh nodedev-detach $VIRSH_CPU_SRAM
virsh nodedev-detach $VIRSH_CPU_USB
virsh nodedev-detach $VIRSH_CPU_THUNDERBOLT

# Load VFIO kernel modules
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
