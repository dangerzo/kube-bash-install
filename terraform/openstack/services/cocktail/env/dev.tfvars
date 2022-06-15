availability_zone   = "nova"
region              = "RegionOne"
key_pair            = "SSH_CUBE"
image_name          = "CentOS7.9-x86_64-2009"
public_network      = "flat"
tenant_network      = "cocktail"
subnet_name         = "cocktail-subnet"
router_name         = "cocktail-router"
tenant_network_mtu  = 1442
tenant_network_cidr = "10.128.10.0/24"
nameservers         = ["8.8.8.8"]

zone_name           = "cocktailcloud.io."
zone_email          = "cube@acornsoft.io"
zone_description    = "cocktail zone"
zone_ttl            = 300
zone_type           = "PRIMARY"

instances = {
  master1 = {
    instance_name     = "cocktail-master01"
    volume_size       = "50"
    flavor_name       = "cocktail.master"
    user_data         = "./cloud-init/cloud-init.sh"
    server_groups     = [""]
    fixed_ip_v4       = "10.128.10.11"
    security_groups   = ["secgroup-master"]
  },
  master2 = {
    instance_name     = "cocktail-master02"
    volume_size       = "50"
    flavor_name       = "cocktail.master"
    user_data         = "./cloud-init/cloud-init.sh"
    server_groups     = [""]
    fixed_ip_v4       = "10.128.10.12"
    security_groups   = ["secgroup-master"]
  },
  master3 = {
    instance_name     = "cocktail-master03"
    volume_size       = "50"
    flavor_name       = "cocktail.master"
    user_data         = "./cloud-init/cloud-init.sh"
    server_groups     = [""]
    fixed_ip_v4       = "10.128.10.13"
    security_groups   = ["secgroup-master"]
  },
  worker1 = {
    instance_name     = "cocktail-worker01"
    volume_size       = "50"
    flavor_name       = "cocktail.worker"
    user_data         = "./cloud-init/cloud-init.sh"
    server_groups     = [""]
    fixed_ip_v4       = "10.128.10.21"
    security_groups   = ["secgroup-worker"]
  },
  worker2 = {
    instance_name     = "cocktail-worker02"
    volume_size       = "50"
    flavor_name       = "cocktail.worker"
    user_data         = "./cloud-init/cloud-init.sh"
    server_groups     = [""]
    fixed_ip_v4       = "10.128.10.22"
    security_groups   = ["secgroup-worker"]
  }
}


flavor_definitions = [
  {
    name = "cocktail.master"
    ram  = "8192"
    vcpu = "4"
    disk = "50"
    is_public = "true"
  },
  {
    name = "cocktail.worker"
    ram  = "4096"
    vcpu = "2"
    disk = "50"
    is_public = "true"
  }
]


secgroups = {
  secgroup-master = {
    name        = "secgroup-master"
    description = ""
    rules       = [
      {
        description      = "Allow ICMP from all"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "icmp"
        port_range_min   = 0
        port_range_max   = 0
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow ICMP to all"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "icmp"
        port_range_min   = 0
        port_range_max   = 0
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow SSH from all"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 22
        port_range_max   = 22
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow Kubernetes API from all"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 6443
        port_range_max   = 6443
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow API between etcd and kube-apiserver"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 2379
        port_range_max   = 2380
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow kubelet API"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 10250
        port_range_max   = 10250
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow kube-scheduler"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 10251
        port_range_max   = 10251
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow kube-controller-manager"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 10252
        port_range_max   = 10252
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow NodePort"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 30000
        port_range_max   = 32767
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico BGP Port"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 179
        port_range_max   = 179
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico BGP Port"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 179
        port_range_max   = 179
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico vxlan networking"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 8472
        port_range_max   = 8472
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico vxlan networking"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 8472
        port_range_max   = 8472
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow all tcp ports of master and worker node"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 1
        port_range_max   = 65535
        remote_ip_prefix = "10.128.10.0/24"
      },
      {
        description      = "Allow all udp ports of master and worker node"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 1
        port_range_max   = 65535
        remote_ip_prefix = "10.128.10.0/24"
      }
    ]
  },

  secgroup-worker = {
    name        = "secgroup-worker"
    description = ""
    rules       = [
      {
        description      = "Allow ICMP from all"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "icmp"
        port_range_min   = 0
        port_range_max   = 0
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow ICMP to all"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "icmp"
        port_range_min   = 0
        port_range_max   = 0
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow SSH from all"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 22
        port_range_max   = 22
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow kubelet API"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 10250
        port_range_max   = 10250
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow NodePort"
        direction        = "ingress"
        ethertype        = "IPv4"
         protocol         = "tcp"
        port_range_min   = 30000
        port_range_max   = 32767
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico BGP Port"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 179
        port_range_max   = 179
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico BGP Port"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 179
        port_range_max   = 179
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico vxlan networking"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 8472
        port_range_max   = 8472
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Calico vxlan networking"
        direction        = "egress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 8472
        port_range_max   = 8472
        remote_ip_prefix = "0.0.0.0/0"
      },
      {
        description      = "Allow all tcp ports of master and worker node"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 1
        port_range_max   = 65535
        remote_ip_prefix = "10.128.10.0/24"
      },
      {
        description      = "Allow all udp ports of master and worker node"
        direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "udp"
        port_range_min   = 1
        port_range_max   = 65535
        remote_ip_prefix = "10.128.10.0/24"
      }
    ]
  }
}

