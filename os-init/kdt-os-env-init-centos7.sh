#!/bin/bash
set -xe

############################
### CUBE OS INIT Scripts ###
############################

# 변경 할 hostname명
hostname=localhost

# 현 PXE구성이 kickstart 실행 후 DEFAULT로 DHCP를 사용.
# DHCP에서 StaticIP로 변경하기 위한 스크립트를 구성하려면 아래 주석 interface,ipaddr 를 해제합니다. (192.168.0.0/24 네트워크에서만 유효함)
function interface_static_configure() {
  #interface=eno4
  #ipaddr=192.168.0.228
}

# kickstart 구성 설치 후 현재 hostname이 localhost으로 되어있어 localhost가 아닌 경우 중단
if [ "$(hostname -f)" != "localhost" ]; then 
  echo "Current hostname is not localhost"
  exit 1
fi

hostnamectl set-hostname $hostname

### Cocktail User Create ###
echo "### Create User Cocktail ###"
useradd cocktail
echo "cocktail:adminWks@2" | chpasswd

### Cocktail user id-rsa key ###
echo "### Cocktail user add Public key ###"
mkdir /home/cocktail/.ssh/

cat <<EOF | sudo tee /home/cocktail/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvAHfOOSpsv7M0DlNmKx33XYcPqTNbUCmaqxuQULNAAubeNhZzlfAYvg2CeDi9d9qFJkjSY0Xd5b2ixkKKg27FuoFnErqCZ7p2cKi3hSaty8YzONNMzk9pVv9ySEmwZkgPhFlSyLA/MfZRM78DNB0nq5HM+r++CNFVi/pfN40eIEhmFX/nW+AH2VvSvPlIyscJhT+1dbp8BS2S3djL+5l31mbXtY7tQXWsHxJ8Ta1vQH5nyvYxpBe7NSjfdjM5S6/ETkx3i+/Ii89MKTdkJcKjlk4TtBFaz5v1kguj18V5i2PvGCdIjgkAm1tafKI2KwnMfXVODjAOQXRpq2KMQukp
EOF

### Cocktail user owner ###
chown -R cocktail.cocktail /home/cocktail

### Cocktail user sudoer add ##
echo "### Cocktail user Add sudoer ###"
cat <<EOF | sudo tee /etc/sudoers.d/cocktail-sudoer
cocktail ALL=(ALL) NOPASSWD: ALL
EOF

### selinux disabled ###
# SSH server Port변경 전 SELinux 비활성화 필요
echo "### Selinux Disable ###"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

### ssh config modify ###
echo "### SSH Config modify ###"
echo "### Port 22 -> 2022, Rootlogin yes -> no, PassAuth yes -> no ###"

sed -i -r "s/^#Port 22/Port 2022/" /etc/ssh/sshd_config
sed -i -r "s/^PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -r "s/^PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

systemctl restart sshd

### firewalld stop ###
echo "### Firewalld Disable ###"
service firewalld stop
systemctl disable firewalld

interface_static_configure
if [ ! -z "$interface" ]; then
  # set to static ip
  sed -n -r 's/BOOTPROTO=dhcp/BOOTPROTO=none/' /etc/sysconfig/network-scripts/ifcfg-$interface
  cat <<EOF >>  /etc/sysconfig/network-scripts/ifcfg-$interface
  IPADDR=$ipaddr
  NETMASK=255.255.255.0
  GATEWAY=192.168.0.5
  DNS1=8.8.8.8
  DNS2=8.8.4.4
EOF

  ifdown $interface
  ifup $interface
fi


### install requite tool ###
echo "### net-tools install ###"
yum install net-tools tar -y

# hostname 변경해도 syslog에 나타나는 hostname이 이전name이므로 필요시 리부트 진행
# reboot