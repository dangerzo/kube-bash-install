# CUBE Package, Container Download Scripts

### [수행 스크립트]
```
├── 00_runtime_download_centos_7x_8x.sh
├── 01_k8s-download-centos7.sh
├── 10_11_cube_dpkg_download.sh
├── container_download.sh
├── static_container_download.sh
├── creatre_container_list.sh
└── etcd_download.sh

```

### [사용법]
```
 - 00_runtime_download_centos_7x_8x.sh
Kubernetes Version 랑 상관없이 Containerd 관련 Package 를 다운받기 위한 스크립트, 스크립트를 바로 수행시키면 됨
ex) sh 00_runtime_download_centos_7x_8x.sh

 - 01_k8s-download-centos7.sh
Kubernetes 관련 Package Download 수행
Kubernetes Package 와 동일한 버전의 Container 를 Pull 한 후 Scripts 에서 지정한 Harbor 저장소해 해당 Container Image Push 를 수행

### Container 를 저장하는 Harbor URL 지정
UPLOAD_HAROBR_URL="dangerzo_harbor.url"

### Donwload kubernetes Package Version, Array ###
DEPRECATED_K8S_VERSION=("1.13" "1.14" "1.15" "1.16" "1.17" "1.18")
RELEASE_K8S_VERSION=("1.19" "1.20" "1.21")

### Package Range, "all", "last" | all -> last 2 version
DEPRECATED_K8S_RANGE="last"
RELEASE_K8S_RANGE="last"

 - container_download.sh
docker login ${UPLOAD_HAROBR_URL} --username dangerzo --password password > ./temp_docker_login_message

Container 를 Push 하기위한 Docker Login 관련된 정보가 Static 하게 정의되어 있으며, 해당 부분은 고도화가 필요함

 - etcd_download.sh 부분은 앞으로 개선할 예정

### static_container_download.sh
URLFILE=./url_list 에 정의된 파일에 container image 를 기록하면 해당 container 들이 "UPLOAD_HAROBR_URL="dangerzo_harbor.url" 여기로 upload 수행, k8s 뿐 아니라 특정 container 이미지를 자동으로 upload 하기위에 기존의 download 스크립트 수정해서 작성

```
