output "flavor_names" {
  value       = ["${openstack_compute_flavor_v2.flavor.*.name}"]
}
