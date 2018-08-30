variable "domain_name" {
  description = "Domain Name such as pgw-webhook"
  default     = "blue-fiesta"
}

variable "server_port" {
  description = "The port will use for HTTP requests"
  default = 80
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-0aef39631ceac4cc1"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "keypair" {
  description = "The keypair name"
  default     = "rtr"
}