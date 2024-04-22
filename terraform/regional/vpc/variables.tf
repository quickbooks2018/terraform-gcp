variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
}

variable "region" {
  description = "The region in which the resources will be deployed"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr_2" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.11.0.0/16"
}

variable "public_subnet_cidr_3" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.12.0.0/16"
}

variable "private_subnet_name" {
  description = "The name of the private subnet"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "20.20.0.0/16"
}

variable "private_subnet_cidr_2" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "20.21.0.0/16"
}

variable "private_subnet_cidr_3" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "20.22.0.0/16"
}

variable "nat_router_name" {
  description = "The name of the NAT router"
  type        = string
}