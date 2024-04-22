module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 8.1"

  project_id   = var.project_id
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${var.public_subnet_name}-01"
      subnet_ip             = var.public_subnet_1_cidr
      subnet_region         = var.public_subnet_1_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "${var.public_subnet_name}-01"
    },
    {
      subnet_name           = "${var.public_subnet_name}-02"
      subnet_ip             = var.public_subnet_2_cidr
      subnet_region         = var.public_subnet_2_region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "${var.public_subnet_name}-02"
    },
    {
      subnet_name               = "${var.public_subnet_name}-03"
      subnet_ip                 = var.public_subnet_3_cidr
      subnet_region             = var.public_subnet_3_region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "${var.private_subnet_name}-01"
      subnet_ip                 = var.private_subnet_1_cidr
      subnet_region             = var.private_subnet_1_region
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      purpose                   = "PRIVATE"
      subnets_private_access    = "true"
    },
    {
      subnet_name            = "${var.private_subnet_name}-02"
      subnet_ip              = var.private_subnet_2_cidr
      subnet_region          = var.private_subnet_2_region
      subnet_private_access  = "true"
      subnet_flow_logs       = "true"
      description            = "This subnet has a description"
      purpose                = "PRIVATE"
      subnets_private_access = "true"
    },
    {
      subnet_name            = "${var.private_subnet_name}-03"
      subnet_ip              = var.private_subnet_3_cidr
      subnet_region          = var.private_subnet_3_region
      subnet_private_access  = "true"
      subnet_flow_logs       = "true"
      description            = "This subnet has a description"
      purpose                = "PRIVATE"
      subnets_private_access = "true"
    },

  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "${var.public_subnet_name}-secondary-range-01"
        ip_cidr_range = "192.168.0.0/16"
      },
    ]

    subnet-02 = []
  }

  routes = [
    {
      name              = "egress-internet-traffic"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },

  ]

}

