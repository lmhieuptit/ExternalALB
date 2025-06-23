variable "zone" {
  description = "The zone where the instance will be created"
  type        = string
}

variable "instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "image" {
  type = string
}

variable "vpc_network_self_link" {
  type = string
}

variable "subnetwork_self_link" {
  type = string
}

variable "network_tags" {
  type = list(string)
}
