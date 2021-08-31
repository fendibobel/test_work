output "server_name" {
  value = openstack_compute_instance_v2.instance[*].name
}

output "server_ip" {
  value = openstack_networking_floatingip_v2.fip[*].address
}

output "server_local_ip" {
  value = openstack_compute_instance_v2.instance[*].network[0].fixed_ip_v4
}
