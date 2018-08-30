variable "domain_name" {
  description = "Domain Name such as pgw-webhook"
  default     = "stage-fiesta"
}

variable "server_port" {
  description = "The port will use for HTTP requests"
  default = 80
}

variable "ami_id" {
  description = "AMI ID"
  default     = "ami-0d34c8b4564f31f43"
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "keypair" {
  description = "The keypair name"
  default     = "rtr"
}