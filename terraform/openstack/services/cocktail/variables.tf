#--------------------#
#    Nova(Instance)  #
#--------------------#
variable "region" {
  type    = string
  default = "RegionOne"
}

variable "availability_zone" {
  type    = string
  default = "nova"
}

variable "key_pair" {
  type = string
}

variable "image_name" {
  type = string
}

variable "instances" {
  type    = map
  default = {
    default-instance = {
      instance_name     = "default-instance"
      volume_size       = "20"
      flavor_name       = "m1.small"
      user_data         = ""
      server_groups     = [""]
      fixed_ip_v4       = ""
      security_groups   = ["default"]
    }
  }
}

#-----------------------#
#    Neutron(Network)   #
#-----------------------#
variable "public_network" {
  type = string
}

variable "tenant_network" {
  type    = string
  default = "tenant"
}

variable "subnet_name" {
  type    = string
  default = "tenant"
}

variable "router_name" {
  type    = string
  default = "tenant-router"
}

variable "tenant_network_mtu" {
  type    = number
}

variable "tenant_network_cidr" {
  type    = string
  default = "10.128.0.0/24"
}

variable "nameservers" {
  type    = list
  default = ["8.8.8.8"]
}


#---------------#
#    Flavors    #
#---------------#
variable "flavor_definitions" {
  type = list(map(any))
  default = [
    {
      name = "m1.small"
      ram  = "2048"
      vcpu = "1"
      disk = "20"
    }
  ]
}


#---------------#
#      SG       #
#---------------#
variable "secgroups" {
  type    = map
}


#------------------------#
#    Designate(DNSaaS)   #
#------------------------#
variable "zone_name" {
  type    = string
  default = "example.com."
}

variable "zone_email" {
  type    = string
  default = "root@localhost"
}

variable "zone_description" {
  type    = string
  default = "example.com zone"
}

variable "zone_type" {
  type    = string
  default = "PRIMARY"
}

variable "zone_ttl" {
  type    = number
  default = 3600
}
