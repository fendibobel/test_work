variable "sel_account" {}

variable "sel_token" {}

variable "project_name" {
  default = "tf_project"
}

variable "user_name" {
  default = "tf_user"
}

variable "user_password" {}

variable "keypair_name" {
  default = "tf_keypair"
}

variable "os_auth_url" {
  default = "https://api.selvpc.ru/identity/v3"
}

variable "os_region" {
  default = "ru-3"
}

variable "server_count" {
  default = 4
}

variable "server_zone" {
  default = "ru-3a"
}

variable "server_vcpus" {
  default = 4
}

variable "server_ram_mb" {
  default = 4096
}

variable "server_root_disk_gb" {
  default = 5
}

variable "server_image_name" {
  default = "Centos 7 64-bit"
}
