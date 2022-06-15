## KDTIDC 구성 코드
KDTIDC 구성을 기록합니다.

### 네트워크 구성
- Private
  - 192.168.0.0/24
  - 192.168.1.0/24
  - 192.168.2.0/24
  - 192.168.3.0/24
  - 192.168.4.0/24
  - 전체 내부 네트워크는 VLAN 100을 사용
  - ! L2 일부 엑서스 포트 VLAN 100 설정이 안되어있음
- Public
  - 101.55.69.0/24 (계약128개.)
- L3
  - NAT 관련 설정 없음
    - natgateway(xen vm) 192.168.0.5 사용중이며 192.168.0.5에서 서브넷간 라우트되지 않음
  - 101.55.69.1
  - 192.168.0.1
  - 192.168.1.1
  - 192.168.2.1
  - 192.168.3.1
  - 192.168.4.1

# DHCP구성

 [/etc/dhcpd/dhcpd.conf](dhcpd.conf) 참조.

 KDT-Bastion에 DHCP 서버 동작 중입니다. 현재 여러 서브넷에 대한 설정 구성되어있으나 192.168.1.0/24, 192.168.2.0/24 에 대한 할당은 동작하지 않습니다. `Bastion서버에 추가적인 네트워크 설정` 또는 `라우터에서 helper-address 구성` 등이 필요합니다. 특수한 이유가 아니면 `192.168.0.24/0` 을 사용하도록 합니다.

 현재 옵션은 `DNS 8.8.8.8, 8.8.4.4`, `Gateway 192.168.0.5` 로 설정 되어 있습니다.

 DHCP에서 `192.168.0.0/24` `192.168.1.0/24` `192.168.2.0/24` 에 대하여 서로 통신이 가능하도록 Stateless Static Route옵션이 추가되어있습니다. `192.168.1.0` 또는 `192.168.2.0` 대역에서 원격 작업 시 ROUTE를 손상시키지 않도록 주의하십시오.

 host가 정의되지 않은 경우 DHCP range `192.168.0.30-59`를 사용하게 되어있습니다. unknown host의 경우 해당 주소를 통해 DHCP IP를 받습니다. **일부 서버가 재시작 될 때 PXE을 통한 OS재설치가 될 수 있으므로 OS설치 작업이 없는 호스트가 PXE로 진행되지 않게 설정해야합니다.**

Host정의 예
 ```
 host apps-107 {
  hardware ethernet 90:17:ac:c2:75:eb;
  fixed-address 192.168.1.107;
}
```

# OS프로비저닝 자동화
`KDT-Bastion`에 DHCP와 TFTP가 동작 중입니다. DHCP서버의 `filename "pxelinux.0";`를 통해 PXE-Client가 인지하고 TFTP서버에서 소형 부트가능파일 PXELinux를 내려받아 로드합니다.
  
- TFTP 구성은 다음에 위치합니다. `/etc/xinetd.d/tftp`
- PXELinux 구성은 다음에 위치합니다. `/tftpboot/pxelinux.cfg/default`
- Kickstart 구성은 다음에 위치합니다. `/var/ftp/pub/ks/`
- `KDT-Bastion` 서버가 재시작 되는 경우 이미지 .iso를 마운트 하십시오.
```
mount -o loop /image/Rocky-8.5-x86_64-dvd1.iso /var/ftp/pub/rocky
mount -o loop /image/CentOS-7-x86_64-DVD-2009.iso /var/ftp/pub/centos
```

## Kickstart 구성
현재 `CentOS 7.9`와 `Rocky Linux 8.5` 두 가지 구성파일을 운용하고 있습니다.

### CentOS 7.9
- CentOS 7.9에서 오토파티셔닝을 진행하는 경우 `/`, `/boot`, `/home` 으로 파티셔닝합니다. 디스크 공간이 50GB 보다 큰 경우에는 나머지 공간을 `/home` 으로 사용하려고 하기 때문에 이는 적절한 옵션이 아닙니다. 따라서 `/` 를 통채로 사용하도록 설정했습니다. **SWAP구성이 없어 SWAP설정이 필요합니다.**

### Rocky Linux 8.5
- 일부 서버에서 RAID카드 드라이버가 존재하지 않아 Rocky Linux를 사용 할 수 없습니다.