provider "openstack" {
  user_name           = var.os_user_name
  tenant_name         = var.os_project_name
  password            = var.os_user_password
  project_domain_name = var.os_domain_name
  user_domain_name    = var.os_domain_name
  auth_url            = var.os_auth_url
  region              = var.os_region
}

resource "random_string" "random_name" {
  length  = 5
  special = false
}

module "flavor" {
  source               = "../flavor"
  flavor_name          = "flavor-${random_string.random_name.result}"
  flavor_vcpus         = var.server_vcpus
  flavor_ram_mb        = var.server_ram_mb
  flavor_local_disk_gb = var.server_root_disk_gb
}

module "nat" {
  source = "../nat"
}

resource "openstack_networking_port_v2" "port" {
  count      = var.server_count
  name       = "eth0-${range(var.server_count)[count.index]}"
  network_id = module.nat.network_id

  fixed_ip {
    subnet_id = module.nat.subnet_id
  }
}

module "image_datasource" {
  source     = "../image_datasource"
  image_name = var.server_image_name
}

module "keypair" {
  source             = "../keypair"
  keypair_name       = "keypair-${random_string.random_name.result}"
  keypair_public_key = var.server_ssh_key
  keypair_user_id    = var.server_ssh_key_user
}


resource "openstack_compute_instance_v2" "instance" {
  count             = var.server_count
  name              = "rmq-${range(var.server_count)[count.index]}"
  image_id          = module.image_datasource.image_id
  flavor_id         = module.flavor.flavor_id
  key_pair          = module.keypair.keypair_name
  availability_zone = var.server_zone

  network {
    port = openstack_networking_port_v2.port[count.index].id
  }

  lifecycle {
    ignore_changes = [image_id]
  }

  vendor_options {
    ignore_resize_confirmation = true
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = "external-network"
  count       = var.server_count
  port_id     = openstack_networking_port_v2.port[count.index].id
}


