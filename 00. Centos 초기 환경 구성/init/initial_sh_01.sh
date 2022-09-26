#!/bin/bash

# Default Install 
echo "=================== Network ================================"
sudo yum update -y
sudo yum install vim curl git wget net-tools -y
sudo sed -i 's/rhgb quiet/rhgb quiet net.ifnames=0 biosdevname=0/g' /etc/default/grub
sudo mv /etc/sysconfig/network-scripts/ifcfg-ens32 /etc/sysconfig/network-scripts/ifcfg-eth0

echo "=================== shutdown Firewall & SELinux ================================"
systemctl stop firewalld ; systemctl disable firewalld
set enforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
cat /proc/sys/net/ipv4/ip_forward

systemctl stop NetworkManager; systemctl disable NetworkManager;
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
yum --enablerepo=elrepo-kernel install kernel-lt -y
grub2-set-default 0

echo "============================= ovs switch ================================"
yum clean all
yum install -y epel-release https://www.rdoproject.org/repos/rdo-release.rpm
yum install -y docker openvswitch bridge-utils
yum update -y
systemctl start openvswitch
systemctl enable openvswitch

# https://atl.kr/dokuwiki/doku.php/openvswitch%EB%A5%BC_%ED%86%B5%ED%95%9C_vxlan_%EA%B5%AC%EC%84%B1

# Ovs Setting 

# ovs-vsctl add-br ovs_sw0
# ip addr add 10.100.0.1/8 dev ovs_sw0 && ip link set dev ovs_sw0 up
# ovs-vsctl add-port ovs_sw0 vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip=192.168.10.164