variable "instance_name" {
  type    = string
}

variable "flavor_name" {
  type    = string
}

variable "region" {
  type    = string
  default = "RegionOne"
}

variable "availability_zone" {
  type    = string
  default = "nova"
}

variable "image_name" {
  type    = string
}

variable "key_pair" {
  type    = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "volume_size" {
  type    = number
  default = 10
}

variable "server_groups" {
  type    = list(string)
  default = []
}

variable "public_network" {
  type    = string
  default = null
}

variable "tenant_network" {
  type    = string
  default = null
}

variable "fixed_ip_v4" {
  type    = string
  default = ""
}

variable "security_groups" {
  type    = list(string)
  default = []
}
