variable "base_image" {
  type    = string
  default = "fedora-43"
}
variable "output_name" {
  type    = string
  default = "main"
}
variable "version" {
  type    = string
  default = "v1.0.0"
}
variable "user_data_path" {
  type    = string
  default = "cloud-init-default.yml"
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}