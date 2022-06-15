data "openstack_networking_network_v2" "public_network" {
  name = "${var.public_network}"
}

resource "openstack_networking_network_v2" "tenant_network" {
  name           = "${var.tenant_network}"
  admin_state_up = "true"
  external	 = "false"
  mtu		 = "${var.mtu}"
  port_security_enabled = "true"
  region  	 = "${var.region}"
  shared	 = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "${var.subnet}"
  network_id = openstack_networking_network_v2.tenant_network.id
  cidr       = "${var.cidr}"
  ip_version = 4
  region     = "${var.region}"
  dns_nameservers = "${var.nameservers}"
}

resource "openstack_networking_router_v2" "router" {
  name		      = "${var.router}"
  region	      = "${var.region}"
  admin_state_up      = true
  enable_snat	      = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "port" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
  region    = "${var.region}"
}
