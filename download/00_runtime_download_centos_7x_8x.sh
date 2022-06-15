#!/bin/bash

CURRENT_PATH=`pwd`
DOWNLOAD_PATH=$CURRENT_PATH/rpm
DOWNLOAD_PATH_CACHE=$CURRENT_PATH/rpm_cache

#####################################
### Download Package, Yum install ###
#####################################
### PRE INSTALL START ###
# createrepo
mkdir -p $DOWNLOAD_PATH
mkdir -p $DOWNLOAD_PATH_CACHE
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH createrepo
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install createrepo

# yum-utils
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH yum-utils
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install yum-utils

# epel-relases
yum -y install epel-release

# wget, net-tools
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH wget
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install wget
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH net-tools
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install net-tools

# nfs-utils
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH nfs-utils
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install nfs-utils


### Container Runtime START ###
# device-mapper-persistent-data
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH device-mapper-persistent-data
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install device-mapper-persistent-data

# lvm2
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH lvm2
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# containerd.io
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH containerd.io
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install containerd.io

### POST INSTALL START ###
# jq
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH jq
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install jq

# docker-ce
yum -y install --downloadonly --downloaddir=$DOWNLOAD_PATH docker-ce
rsync -azvh $DOWNLOAD_PATH/ $DOWNLOAD_PATH_CACHE/
yum clean packages
yum -y install docker-ce


######################
### Delete Package ###
######################
 
echo ""
echo "### Delete POST INSTALL Package ###"
echo ""
echo "### Start remove Docker-CE ###"
yum -y remove docker-ce
echo ""
echo "### Start remove jq ###"
yum -y remove jq
echo ""
echo "### Start remove containerd.io ###"
yum -y remove containerd.io
echo ""
echo "### Delete Container Runtime Package ###"
echo ""
echo "### Start remove lvm2 ###"
yum -y remove lvm2
echo ""
echo "### Start remove device-mapper-persistent-data ###"
yum -y remove device-mapper-persistent-data
echo ""
echo "### Delete Default Dependecy Package ###"
echo ""
echo "### Start remove nfs-utils ###"
yum -y remove nfs-utils
echo ""
echo "### Start remove wget ###"
yum -y remove wget
echo ""
echo "### Start remove net-tools ###"
yum -y remove net-tools
echo ""
echo "### Start remove epel-release ###"
yum -y remove epel-release
echo ""
echo "### Start remove yum-utils ###"
yum -y remove yum-utils
echo ""
echo "### Start remove createrepo ###"
yum -y remove createrepo

echo "Finish Download Runtime Package"

