variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
}

variable "vpc_name" {
    description = "The name of the VPC to deploy to"
    type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "database_version" {
  description = "The version of the database"
  type        = string
}

variable "disk_size" {
  description = "The size of the disk"
  type        = number
}

variable "disk_type" {
  description = "The type of the disk"
  type        = string
}

variable "disk_autoresize" {
  description = "Whether the disk should autoresize"
  type        = bool
}

variable "availability_type" {
  description = "The availability type of the database"
  type        = string
}

variable "edition" {
  description = "The edition of the database"
  type        = string
}

variable "tier" {
  description = "The tier of the database"
  type        = string
}

variable "db_user" {
  description = "The user to create the database with"
  type        = string
}

variable "db_password" {
  description = "The password to create the database with"
  type        = string
}