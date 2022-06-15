data "openstack_images_image_v2" "image" {
  name = "${var.image_name}"
  most_recent = true
}

resource "openstack_compute_instance_v2" "instance" {
  name              = "${var.instance_name}"
  flavor_name       = "${var.flavor_name}"
  region            = "${var.region}"
  availability_zone = "${var.availability_zone}"
  image_name        = "${var.image_name}"
  key_pair          = "${var.key_pair}"
  user_data         = "${var.user_data}"
  security_groups   = "${var.security_groups}"

  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    volume_size           = "${var.volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name        = "${var.tenant_network}"
    fixed_ip_v4 = "${var.fixed_ip_v4}"
  }

  dynamic "scheduler_hints" {
    for_each = var.server_groups

    content {
      group  = scheduler_hints.value
    }
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool   = "${var.public_network}"
  region = "${var.region}"
}

resource "openstack_compute_floatingip_associate_v2" "ipa" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.instance.id
}
