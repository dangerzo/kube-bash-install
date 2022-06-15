#!/bin/bash

##################################
### Remove dpkg ###
##################################

echo "Remove Packages"

sudo rm -rf /root/dpkg/
sudo rm -rf /var/cache/apt/archive/*.deb

#####################################
### Download Package, apt install ###
#####################################

echo "PRE Install Packages"

### PRE INSTALL START ###
# dpkg-dev
sudo mkdir -p /root/dpkg/00_localrepo/00_dpkg-dev
sudo apt-get --download-only install -y --reinstall dpkg-dev && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/00_localrepo/00_dpkg-dev

# nginx
sudo mkdir -p /root/dpkg/00_localrepo/01_nginx
sudo apt-get --download-only install -y --reinstall nginx && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/00_localrepo/01_nginx

# wget, net-tools
sudo mkdir -p /root/dpkg/01_default/00_wget
sudo apt-get --download-only install -y --reinstall wget && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/01_default/00_wget
sudo apt-get --download-only install -y --reinstall net-tools && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/01_default/00_wget

# nfs-utils
sudo mkdir -p /root/dpkg/01_default/01_nfs-kernel-server
sudo apt-get --download-only install -y --reinstall nfs-kernel-server && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/01_default/01_nfs-kernel-server

# selinux-basics
sudo mkdir -p /root/dpkg/01_default/02_selinux-basics
sudo apt-get --download-only install -y --reinstall selinux-basics && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/01_default/02_selinux-basics

### Container Runtime START ###
echo "Install Container"
# containerd.io
sudo apt-get install -y apt-transport-https
sudo rm -rf /var/cache/apt/archives/*.deb
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo mkdir -p /root/dpkg/02_runtime/00_containerd
sudo apt-get --download-only install -y --reinstall containerd.io && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/02_runtime/00_containerd

### Kubernetes START ###
echo "Install Kubernetes"
echo "### Kubeadm install ###"
sudo mkdir -p /root/dpkg/03_kubernetes/00_utils
sudo apt-get --download-only install -y --reinstall apt-transport-https && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/00_utils
sudo apt-get --download-only install -y --reinstall ca-certificates && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/00_utils
sudo apt-get --download-only install -y --reinstall curl && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/00_utils

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo rm -rf /var/cache/apt/archives/*.deb

sudo mkdir -p /root/dpkg/03_kubernetes/01_cni
sudo apt-get --download-only install -y --reinstall conntrack && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/01_cni
sudo apt-get --download-only install -y --reinstall cri-tools && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/01_cni
sudo apt-get --download-only install -y --reinstall ebtables && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/01_cni
sudo apt-get --download-only install -y --reinstall socat && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/01_cni
sudo apt-get --download-only install -y --reinstall kubernetes-cni && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/01_cni

# kubernetes 1.13
LAST_KUBE_VERSION_113=(`apt-cache madison kubeadm | grep 1.13\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.13
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_113} kubelet=${LAST_KUBE_VERSION_113} kubeadm=${LAST_KUBE_VERSION_113} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.13

# kubernetes 1.14
LAST_KUBE_VERSION_114=(`apt-cache madison kubeadm | grep 1.14\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.14
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_114} kubelet=${LAST_KUBE_VERSION_114} kubeadm=${LAST_KUBE_VERSION_114} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.14

# kubernetes 1.15
LAST_KUBE_VERSION_115=(`apt-cache madison kubeadm | grep 1.15\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.15
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_115} kubelet=${LAST_KUBE_VERSION_115} kubeadm=${LAST_KUBE_VERSION_115} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.15

# kubernetes 1.16
LAST_KUBE_VERSION_116=(`apt-cache madison kubeadm | grep 1.16\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.16
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_116} kubelet=${LAST_KUBE_VERSION_116} kubeadm=${LAST_KUBE_VERSION_116} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.16

# kubernetes 1.17
LAST_KUBE_VERSION_117=(`apt-cache madison kubeadm | grep 1.17\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.17
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_117} kubelet=${LAST_KUBE_VERSION_117} kubeadm=${LAST_KUBE_VERSION_117} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.17

# kubernetes 1.18
LAST_KUBE_VERSION_118=(`apt-cache madison kubeadm | grep 1.18\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.18
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_118} kubelet=${LAST_KUBE_VERSION_118} kubeadm=${LAST_KUBE_VERSION_118} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.18

# kubernetes 1.19
LAST_KUBE_VERSION_119=(`apt-cache madison kubeadm | grep 1.19\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.19
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_119} kubelet=${LAST_KUBE_VERSION_119} kubeadm=${LAST_KUBE_VERSION_119} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.19

# kubernetes 1.20
LAST_KUBE_VERSION_120=(`apt-cache madison kubeadm | grep 1.20\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.20
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_120} kubelet=${LAST_KUBE_VERSION_120} kubeadm=${LAST_KUBE_VERSION_120} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.20

# kubernetes 1.21
LAST_KUBE_VERSION_121=(`apt-cache madison kubeadm | grep 1.21\\. | awk {'print $3'} | sort -t '.' -k3 -n | uniq | tail -n 1`)

sudo mkdir -p /root/dpkg/03_kubernetes/1.21
sudo apt-get --download-only install -y --reinstall --allow-downgrades --allow-change-held-packages kubectl=${LAST_KUBE_VERSION_121} kubelet=${LAST_KUBE_VERSION_121} kubeadm=${LAST_KUBE_VERSION_121} && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/03_kubernetes/1.21

### POST INSTALL START ###
# jq
sudo mkdir -p /root/dpkg/04_utils/00_jq
sudo apt-get --download-only install -y --reinstall jq && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/04_utils/00_jq

sudo mkdir -p /root/dpkg/04_utils/01_docker
sudo apt-get --download-only install -y --reinstall docker.io && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/04_utils/01_docker

### NVIDIA INSTALL START
sudo mkdir -p /root/dpkg/05_gpu/00_nvidia-container-runtime
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get --download-only install -y --reinstall nvidia-container-runtime && sudo mv /var/cache/apt/archives/*.deb /root/dpkg/05_gpu/00_nvidia-container-runtime