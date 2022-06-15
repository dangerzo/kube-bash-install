#!/bin/bash


preinstall() {
    useradd cocktail; sleep 1
    echo '!!@@Zbqm3344' | passwd --stdin cocktail; sleep 1
    sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/' /etc/ssh/sshd_config; sleep 1
    sed -i '70 i\PasswordAuthentication yes\' /etc/ssh/sshd_config; sleep 1
    systemctl restart sshd

cat <<EOF | sudo tee /etc/sudoers.d/cocktail
cocktail    ALL=(ALL)    NOPASSWD: ALL
EOF


cat<<EOF | sudo tee /etc/security/limits.d/cocktail
cocktail    soft    nproc    8192
cocktail    hard    nproc    8192
cocktail    soft    nofile   65536
cocktail    hard    nofile   65536
EOF


cat <<EOF | sudo tee /etc/modules-load.d/overlay.conf
overlay
br_netfilter
EOF
	

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward  = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

    sudo modprobe overlay
    sudo modprobe br_netfilter
    sudo sysctl --system

cat <<EOF | sudo tee /etc/sysctl.d/default.conf
vm.swappiness = 10
net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576
fs.aio-max-nr=1048576
fs.file-max=26234859
vm.zone_reclaim_mode=0
vm.min_free_kbytes=67584
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
}

preinstall


exit 0
