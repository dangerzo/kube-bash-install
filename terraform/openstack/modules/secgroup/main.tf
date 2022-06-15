resource "openstack_networking_secgroup_v2" "sg" {
  name                 = "${var.name}"
  description          = "${var.description}"
}

resource "openstack_networking_secgroup_rule_v2" "rules" {
  count             = "${length(var.rules)}"
  description       = "${var.rules[count.index].description}"
  direction         = "${var.rules[count.index].direction}"
  ethertype         = "${var.rules[count.index].ethertype}"
  protocol          = "${var.rules[count.index].protocol}"
  port_range_min    = "${var.rules[count.index].port_range_min}"
  port_range_max    = "${var.rules[count.index].port_range_max}"
  remote_ip_prefix  = "${var.rules[count.index].remote_ip_prefix}"
  security_group_id = openstack_networking_secgroup_v2.sg.id
}
