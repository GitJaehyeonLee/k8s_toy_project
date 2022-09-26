#!/bin/bash

# Default Install 
echo "========================= Virt install Test ================================"
yum -y install qemu-kvm virsh virt-install libvirt virt-manager libguestfs-tools libguestfs-xfs
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf
sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf

systemctl daemon-reload
systemctl restart libvirtd
systemctl enable libvirtd

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install libvirt-daemon-kvm libvirt-client vagrant gcc-c++ make libstdc++-devel libvirt-devel
systemctl restart libvirtd
vagrant plugin install vagrant-libvirt