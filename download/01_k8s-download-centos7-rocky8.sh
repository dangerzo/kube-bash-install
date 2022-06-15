#!/bin/bash

URLFILE=./url_list
UPLOAD_HAROBR_URL="cube-regi-ent.acloud.run"

##########################################
### Variable Global Kubernetes Version ###
##########################################
### Donwload kubernetes Package Version, Array ###
DEPRECATED_K8S_VERSION=("1.13" "1.14" "1.15" "1.16" "1.17" "1.18")
RELEASE_K8S_VERSION=("1.19" "1.20" "1.21" "1.22" "1.23" "1.24")

### Package Range, "all", "last" | all -> last 2 version
DEPRECATED_K8S_RANGE="last"
RELEASE_K8S_RANGE="last"


###############################
### kubernetes yum repo add ###
###############################
sudo bash -c 'cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

sudo yum update repo -y


##########################################
### Define Download Kubernetes Package ###
##########################################
for ((k=0; k<${#DEPRECATED_K8S_VERSION[@]}; k++));
do
  if [ "${DEPRECATED_K8S_RANGE}" == "all" ]; then
    CUBE_VERSION=(`yum --showduplicates list kubeadm --disableexcludes=kubernetes | grep ${DEPRECATED_K8S_VERSION[$k]} | awk {'print $2'} | sort -t '.' -k3 -n | uniq | awk -F "-" '{print $1}'`)
  elif [ "${DEPRECATED_K8S_RANGE}" == "last" ]; then
    CUBE_VERSION=(`yum --showduplicates list kubeadm --disableexcludes=kubernetes | grep ${DEPRECATED_K8S_VERSION[$k]} | awk {'print $2'} | sort -t '.' -k3 -n | uniq | awk -F "-" '{print $1}' | tail -n 1`)
  else
    echo "check download range var input, \"all\" or \"last\""
    exit 0
  fi

  sudo mkdir -p /root/rpm/03_kubernetes/${DEPRECATED_K8S_VERSION[$k]}

###################################
### Donwload Kubernetes Package ###
###################################
  for ((i=0; i<${#CUBE_VERSION[@]}; i++));
  do
    yum -y install --downloadonly --downloaddir=/root/rpm/03_kubernetes/${DEPRECATED_K8S_VERSION[$k]} kubectl-${CUBE_VERSION[$i]} kubelet-${CUBE_VERSION[$i]} kubeadm-${CUBE_VERSION[$i]} --disableexcludes=kubernetes

    sh ./creatre_container_list.sh ${CUBE_VERSION[$i]}
    sleep 2

    sh ./container_download.sh $URLFILE ${CUBE_VERSION[$i]} $UPLOAD_HAROBR_URL
    sleep 2
  done
done

##########################################
### Define Download Kubernetes Package ###
##########################################
for ((k=0; k<${#RELEASE_K8S_VERSION[@]}; k++));
do
  if [ "${RELEASE_K8S_RANGE}" == "all" ]; then
    CUBE_VERSION=(`yum --showduplicates list kubeadm --disableexcludes=kubernetes | grep ${RELEASE_K8S_VERSION[$k]} | awk {'print $2'} | sort -t '.' -k3 -n | uniq | awk -F "-" '{print $1}'`)
  elif [ "${RELEASE_K8S_RANGE}" == "last" ]; then
    CUBE_VERSION=(`yum --showduplicates list kubeadm --disableexcludes=kubernetes | grep ${RELEASE_K8S_VERSION[$k]} | awk {'print $2'} | sort -t '.' -k3 -n | uniq | awk -F "-" '{print $1}' | tail -n 1`)
  else
    echo "check download range var input, \"all\" or \"last\""
    exit 0
  fi

  sudo mkdir -p /root/rpm/03_kubernetes/${RELEASE_K8S_VERSION[$k]}

###################################
### Donwload Kubernetes Package ###
###################################
  for ((i=0; i<${#CUBE_VERSION[@]}; i++));
  do
    yum -y install --downloadonly --downloaddir=/root/rpm/03_kubernetes/${RELEASE_K8S_VERSION[$k]} kubectl-${CUBE_VERSION[$i]} kubelet-${CUBE_VERSION[$i]} kubeadm-${CUBE_VERSION[$i]} --disableexcludes=kubernetes

    sh ./creatre_container_list.sh ${CUBE_VERSION[$i]}
    sleep 2

    sh ./container_download.sh $URLFILE ${CUBE_VERSION[$i]} $UPLOAD_HAROBR_URL
    sleep 2
  done
done
