variable "public_network" { type = string }
variable "tenant_network" { type = string }
variable "subnet" { type = string }
variable "cidr" { type = string }
variable "router" { type = string }
variable "nameservers" { type = list(string) }
variable "region" { type = string }
variable "mtu" { type = number }
