terraform {
required_version = ">= 1.0.2"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.43.0"
    }
  }
}

module "flavor" {
  source = "../../modules/flavor"
  
  flavor_definitions = var.flavor_definitions
}

module "network" {
  source	 = "../../modules/network"

  region	 = var.region
  public_network = var.public_network
  router	 = var.router_name
  tenant_network = var.tenant_network
  subnet	 = var.subnet_name
  mtu		 = var.tenant_network_mtu
  cidr		 = var.tenant_network_cidr
  nameservers    = var.nameservers
}

module "secgroup" {
  source      = "../../modules/secgroup"

  for_each    = var.secgroups
  
  name        = each.value.name
  description = each.value.description
  rules       = each.value.rules
}

module "instance" {
  source            = "../../modules/instance"
  depends_on        = [module.network, module.secgroup]

  region            = var.region
  availability_zone = var.availability_zone
  key_pair          = var.key_pair
  image_name        = var.image_name
  public_network    = var.public_network
  tenant_network    = var.tenant_network

  for_each          = var.instances

  instance_name     = each.value.instance_name
  flavor_name       = each.value.flavor_name
  volume_size	    = each.value.volume_size
  user_data         = each.value.user_data
  fixed_ip_v4       = each.value.fixed_ip_v4
  server_groups     = each.value.server_groups
  security_groups   = each.value.security_groups
}

resource "openstack_dns_zone_v2" "zone" {
  name        = "${var.zone_name}"
  email       = "${var.zone_email}"
  description = "${var.zone_description}"
  ttl         = "${var.zone_ttl}"
  type        = "${var.zone_type}"
}

resource "openstack_dns_recordset_v2" "recordset" {
  for_each    = var.instances

  zone_id     = openstack_dns_zone_v2.zone.id
  name        = "${each.value.instance_name}.${var.zone_name}"
  description = "${each.value.instance_name}"
  ttl         = var.zone_ttl
  type        = "A"
  records     = [each.value.fixed_ip_v4]
}
