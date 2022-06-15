# cube 5.2.3 설치 가이드

### **수행 스크립트**  
```
├── 01_master_env_init.sh
├── 02_copy_ca.sh
├── 03_kubeadm_init.sh
├── 04_acloud_user_add.sh
├── 05_metrics-server.sh
├── 09_worker_join.sh
├── 51_upgrade_kubernetes.sh
├── 52_upgrade_etcd.sh
├── 53_upgrade_calico.sh
├── 91_private_registry.sh
├── 92_private_harbor.sh
├── 99_delete_node.sh
├── amazon
│   ├── 00_unzip_cubefile.sh
│   ├── 01_create_openssl.sh
│   ├── 02_certificate.sh
│   ├── 03_kubeconfig_create.sh
│   ├── 04_audit.sh
│   ├── 05_async_kubeadm_pki.sh
│   ├── 06_etcd_bootstrap.sh
│   ├── 07_kubeadm_config_yaml_init.sh
│   ├── 08_cube_install.sh
│   └── 09_haproxy_static_pod.sh
├── calico
│   │── 3.9
│   │   └── calico.yaml
│   ├── 3.13
│   │   └── calico.yaml
│   ├── 3.17
│   │   └── calico.yaml
│   └── 3.20
│       └── calico.yaml
├── centos
│   ├── 00_unzip_cubefile.sh
│   ├── 01_create_openssl.sh
│   ├── 02_certificate.sh
│   ├── 03_kubeconfig_create.sh
│   ├── 04_audit.sh
│   ├── 05_async_kubeadm_pki.sh
│   ├── 06_etcd_bootstrap.sh
│   ├── 07_kubeadm_config_yaml_init.sh
│   ├── 08_cube_install.sh
│   └── 09_haproxy_static_pod.sh
├── ubuntu
│   ├── 00_unzip_cubefile.sh
│   ├── 01_create_openssl.sh
│   ├── 02_certificate.sh
│   ├── 03_kubeconfig_create.sh
│   ├── 04_audit.sh
│   ├── 05_async_kubeadm_pki.sh
│   ├── 06_etcd_bootstrap.sh
│   ├── 07_kubeadm_config_yaml_init.sh
│   ├── 08_cube_install.sh
│   └── 09_haproxy_static_pod.sh
├── helm
│   ├── cocktail.yaml
│   ├── csi-driver-nfs.yaml
│   └── metrics-server.yaml
├── cocktail-addon
│   ├── kafka-main
│   │   ├── add_user.sh
│   │   ├── clear.sh
│   │   ├── generate.sh
│   │   ├── info.sh
│   │   ├── make_kafka_collector.sh
│   │   └── README.md
│   ├── kiali
│   │   └── kiali-create-cefiticate.sh
│   └── loki
│       ├── clear.sh
│       ├── generate_ca.sh
│       ├── generate.sh
│       ├── info.sh
│       └── README.md
└── cube_env
```
  
##### [CUBE 작업 Flow]

1. Private Package REPO 구성
2. Private Container REPO 구성
3. prerequisite system 구성
4. 사설인증서 구성 (kubernetes, etcd)
5. external kubeconfig 파일 생성
6. Root CA 파일 복사 (Kubernetes, etcd)
7. kubeadm 설치용 yaml 구성
8. kubeadm prerequisite 구성
9. kubeadm init 수행
10. Static Pod 추가 구성 (Haproxy static pod)
11. Worker Node Join 수행


### [사용자설정 파일]

### cube_env

- **CUBE_VERSION** = 설치하고자 하는 kubernetes 버전을 입력, ex. 1.18.19
- **CUBE_ENV_CLUSTER_IP** = 인증서에 사용되는 CLUSTER_IP 값
- **CUBE_ENV_PROXY_IP** = Master APISERVER 가 연결될 Loadbalancer 의 IP (대표IP)
- **CUBE_ENV_EXTERNAL_DNS** = Master APISERVER IP 에 연결될 도메인 정보 
- **CLUSTER_NAME** = 설치되는 kubernetes name, kubeadm config yaml 에 적용
- **HOSTNAME** = hostname 이 필요할때 적용 (command 로 자동적용)
- **NODE_IP** = local ip 값 (command 로 자동적용)
- **OS_TYPE** = 설치대상 OS 배포판 확인 (command 로 자동적용)
- **MASTER_HOSTNAME** = master01, master02, master03 이렇게 기본 정의하였으며, 실 master 서버의 hostname 을 입력
- **MASTER_NODE_IP** = 각 Master Node 의 IP 값 입력
- **SERVICE_SUBNET** = kubeadm 의 "serverSubnet" 에 적용될 값 - 해당값은 Kubernetes 의 Cluster Subnet 에서 사용됨
- **POD_SUBNET** = kubeadm 의 "podSubnet" 에 적용될 값 - 해당값은 Pod 의 Network 에서 사용될 Subnet 값
- **CLUSTER_DNS** = kubeadm 의 "clusterDns" 에 적용될 값 - 해당값은 serverSernet 의 CIDR 값을 참조해서 구성ex. serverSubnet 이 10.96.0.0/12 인경우 clusterDns 값은 10.96.0.10, CUBE_ENV_CLUSTER_IP 값은 10.96.0.1 구성
- **NETWORK_TYPE** = 네트워크 환경 선택 "public | private"
- **GPU_NODE** = GPU 환경 확인 "disable | enable"
- **PRIVATE_REPO** = Private Repo 선택 (네트워크 환경이 Private 일 때 해야 함, 해당 환경설정값은 추 후 제거예정)
- **REPO_URL** = Private Package Repo IP 입력 (YUM, APT 등)
- **HARBOR_URL** = Private Container Repo IP 입력
- **CUBE_HARBOR_VERSION** = Private Container Repo 인 Harbor 버전 입력
- **CUBE_WORK** = 작업 디렉터리 설정
- **CUBE_DATA** = containerd, etcd 등의 데이터가 저장되는 위치
- **CUBE_TMP** = 작업 디렉터리 하위의 임시 디렉토리 정의
- **CUBE_EXEC** = 작업 디렉터리 중 실행파일이 저장되는 위치
- **AWS_SERVER** = AWS 클라우드 환경에서 구축 시 설정 "disable | enable"


### [작업전 해야할일]

- master01, 02, 03 서버의 hostname 을 수정 - "hostnamectl set-hostname master01" 명령어로 각각의 서버마다 master01, 02, 03 으 hostname 값 수정반영
- 설치할 Master 서버의 IP값 확인 - cube_env 에 해당값을 입력
- kubernetes apiserver 의 Loadbalancer IP 값 확인
- kubernetes cluster name 정의
- 설치할 kubernetes 버전 정의 - 해당값은 설치파일 구성시 필요하기에 미리 정의되어 있어야 함
- kubernetes cluster 에서 사용할 CIDR 값 정의
- kubernetes Pod 에서 사용할 CIDR 값 정의
- REPO 서버의 IP 및 Prt 값 확인
- Harbor 서버의 IP 값 확인

