# cube terraform architecture

### **수행 스크립트**  
```
terraform/
├── openstack
│   ├── modules
│   │   ├── flavor
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── provider.tf
│   │   │   └── variables.tf
│   │   ├── instance
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── provider.tf
│   │   │   └── variables.tf
│   │   ├── network
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── provider.tf
│   │   │   └── variables.tf
│   │   └── secgroup
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── provider.tf
│   │       └── variables.tf
│   └── services
│       └── cocktail
│           ├── cloud-init
│           │   └── cloud-init.sh
│           ├── clouds.yaml
│           ├── env
│           │   ├── dev.tfvars
│           │   ├── prd.tfvars
│           │   └── stg.tfvars
│           ├── main.tf
│           └── variables.tf
```
  
##### Prerequisites

1. SSH Key 생성
2. public 네트워크 생성
3. QCOW2 이미지 업로드
4. (optional) Designate(DNSaaS) 서비스 설치완료


### [사용자설정 파일]

### env/*.tfvars (dev, stg, prd 환경에 맞게 편집)


### [작업전 해야할일]

- 설치된 오픈스택 클러스터에 맞는 clouds.yaml 다운로드하여 services/cocktail 아래에 업로드
- env/*.tfvars에 알맞는 변수값 편집
- cloud-init/cloud-init.sh 스크립트를 알맞게 편집해서, 생성할 계정 및 패스워드를 변경
