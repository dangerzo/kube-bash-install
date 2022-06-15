#!/bin/bash

KUBEADM_VERSION=$1

if [ "${KUBEADM_VERSION}" == "1.19" ] || [ "${KUBEADM_VERSION}" == "1.20" ] || [ "${KUBEADM_VERSION}" == "1.21" ]; then
  ETCD_VER=v3.4.13
elif [ "${KUBEADM_VERSION}" == "1.17" ] || [ "${KUBEADM_VERSION}" == "1.18" ]; then
  ETCD_VER=v3.4.3
elif [ "${KUBEADM_VERSION}" == "1.22" ]; then
  ETCD_VER=v3.5.0
else
  echo "check download etcd dependency by kubernetes version"
  sleep 5
  exit 0
fi

echo $ETCD_VER

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -rf ./etcd_download
mkdir -p ./etcd_download

rm -f ./etcd_download/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf ./etcd_download/etcd-download-test && mkdir -p ./etcd_download/etcd-download-test

wget ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -P ./etcd_download/
tar xzvf ./etcd_download/etcd-${ETCD_VER}-linux-amd64.tar.gz -C ./etcd_download/etcd-download-test  --strip-components=1
rm -f ./etcd_download/etcd-${ETCD_VER}-linux-amd64.tar.gz

chown -R root.root ./etcd_download

./etcd_download/etcd-download-test/etcd --version
./etcd_download/etcd-download-test/etcdctl version
