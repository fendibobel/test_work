output "server_name" {
  value = module.servers_rmq.server_name
}

output "server_ip" {
  value = join(" ", module.servers_rmq.server_ip)
}

output "server_local_ip" {
  value = join(" ", module.servers_rmq.server_local_ip)
}

