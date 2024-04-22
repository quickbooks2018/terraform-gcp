variable "project_id" {
    description = "The project ID to deploy to"
    type = string
}

variable "region" {
    description = "The region to deploy to"
    type = string
}

variable "vpc_name" {
    description = "The name of the VPC to create"
    type = string
}

variable "public_subnet_name" {
    description = "The name of the public subnet to create"
    type = string
}

variable "public_subnet_1_cidr" {
    description = "The CIDR block of the public subnet"
    type = string
}

variable "public_subnet_1_region" {
    description = "The region of the public subnet"
    type = string
}

variable "public_subnet_2_cidr" {
    description = "The CIDR block of the public subnet"
    type = string
}

variable "public_subnet_2_region" {
    description = "The region of the public subnet"
    type = string
}

variable "public_subnet_3_cidr" {
    description = "The CIDR block of the public subnet"
    type = string
}

variable "public_subnet_3_region" {
    description = "The region of the public subnet"
    type = string
}

variable "private_subnet_name" {
    description = "The name of the private subnet to create"
    type = string
}

variable "private_subnet_1_cidr" {
    description = "The CIDR block of the private subnet"
    type = string
}

variable "private_subnet_1_region" {
    description = "The region of the private subnet"
    type = string
}

variable "private_subnet_2_cidr" {
    description = "The CIDR block of the private subnet"
    type = string
}

variable "private_subnet_2_region" {
    description = "The region of the private subnet"
    type = string
}

variable "private_subnet_3_cidr" {
    description = "The CIDR block of the private subnet"
    type = string
}

variable "private_subnet_3_region" {
    description = "The region of the private subnet"
    type = string
}