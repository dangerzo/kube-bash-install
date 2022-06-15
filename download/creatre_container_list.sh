#!/bin/bash
###############
### KUBEADM ###
###############
KUBEADM_VERSION=$1

### Check kubeadm Tasking Version
echo "${KUBEADM_VERSION}"

if [ -z "${KUBEADM_VERSION}" ];then
	echo "kubeadm version check plz"
        exit 0
elif [ -n "${KUBEADM_VERSION}" ];then
	echo "kubeadm version checking Good!"
else
	echo "kubeadm version check plz"
        exit 0
fi

yum remove -y kubeadm --disableexcludes=kubernetes
yum remove -y kubectl --disableexcludes=kubernetes
yum remove -y kubelet --disableexcludes=kubernetes

DOWNLOAD_VERSION=`yum --showduplicates list kubeadm --disableexcludes=kubernetes | grep $KUBEADM_VERSION | awk {'print $2'} | tail -n 1`
yum -y install kubectl-$DOWNLOAD_VERSION --disableexcludes=kubernetes
yum -y install kubelet-$DOWNLOAD_VERSION --disableexcludes=kubernetes
yum -y install kubeadm-$DOWNLOAD_VERSION --disableexcludes=kubernetes
KUBEADM_CURRNET_VERSION=`rpm -qa | grep kubeadm`
current_kubeadm_list=`kubeadm config images list --kubernetes-version ${KUBEADM_VERSION} | grep -v etcd`
echo "${current_kubeadm_list[*]}" > ./url_list
