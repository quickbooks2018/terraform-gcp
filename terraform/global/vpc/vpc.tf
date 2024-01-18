module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 8.1"

  project_id   = "playground-s-11-26193514"
  network_name = "terraform-global-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "us-central1-public-subnet-01"
      subnet_ip             = "10.10.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    },
    {
      subnet_name           = "us-east1-public-subnet-02"
      subnet_ip             = "10.20.0.0/16"
      subnet_region         = "us-east1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    },
    {
      subnet_name               = "us-west1-public-subnet-03"
      subnet_ip                 = "10.30.0.0/16"
      subnet_region             = "us-west1"
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name               = "us-west1-private-subnet-01"
      subnet_ip                 = "10.50.0.0/16"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      purpose                   = "PRIVATE"
      subnets_private_access    = "true"
    },
    {
      subnet_name            = "us-east1-private-subnet-02"
      subnet_ip              = "10.60.0.0/16"
      subnet_region          = "us-east1"
      subnet_private_access  = "true"
      subnet_flow_logs       = "true"
      description            = "This subnet has a description"
      purpose                = "PRIVATE"
      subnets_private_access = "true"
    },
    {
      subnet_name            = "us-central1-private-subnet-03"
      subnet_ip              = "10.70.0.0/16"
      subnet_region          = "us-central1"
      subnet_region          = "us-central1"
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
        range_name    = "subnet-01-secondary-01"
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

