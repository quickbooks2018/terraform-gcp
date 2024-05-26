# https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest
# google_client_config and kubernetes provider must be explicitly specified like the following.

data "terraform_remote_state" "vpc" {
  backend = "gcs"
  config = {
    bucket = "cloudgeeks-terraform"
    prefix = "terraform/state/global/vpc"
  }
}



data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "playground-s-11-c10bbbc2"
  name                       = "gke-us-central1-cluster-01"
  regional                   = true
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-c"]
  network                    = data.terraform_remote_state.vpc.outputs.vpc.network.network.name
  subnetwork                 = "private-subnet-01"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  release_channel            = "STABLE"

  node_pools = [
    {
      name                   = "stateless-apps-node-pool"
      machine_type           = "e2-medium"
      node_locations         = "us-central1-a,us-central1-b,us-central1-c"
      min_count              = 1
      max_count              = 3
      local_ssd_count        = 0
      spot                   = true
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      enable_gcfs            = false
      enable_gvnic           = false
      logging_variant        = "DEFAULT"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      preemptible            = false
      initial_node_count     = 1
    },
    {
      name                   = "stateful-apps-node-pool"
      machine_type           = "e2-medium"
      node_locations         = "us-central1-a,us-central1-b,us-central1-c"
      min_count              = 1
      max_count              = 3
      local_ssd_count        = 0
      spot                   = false
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      enable_gcfs            = false
      enable_gvnic           = false
      logging_variant        = "DEFAULT"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      preemptible            = false
      initial_node_count     = 1
    }
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    stateless-apps-node-pool = {
      stateless-apps-node-pool = true
      stateless                = "true"
    },
    stateful-apps-node-pool = {
      stateful-apps-node-pool = true
      stateful                = "true"
    }

  }

  node_pools_metadata = {
    all = {}

    stateless-apps-node-pool = {
      stateless-apps-node-pool = "true"
    },
    stateful-apps-node-pool = {
      stateful-apps-node-pool = "true"
    }
  }

  node_pools_taints = {
    all = []

    stateless-apps-node-pool = [
      {
        key    = "stateless-apps-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ],
    stateful-apps-node-pool = [
      {
        key    = "stateful-apps-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

  }

  node_pools_tags = {
    all = []

    stateless-apps-node-pool = [
      "stateless-apps-node-pool",
    ],
    stateful-apps-node-pool = [
      "stateful-apps-node-pool",
    ]
  }
}
