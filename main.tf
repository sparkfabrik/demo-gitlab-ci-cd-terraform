provider "google" {
  version = "~> 3.16.0"
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket  = "d3-webinar-tf-state"
    prefix  = "terraform/state"
  }
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = var.zones
  # Using GCP defaults.
  network                    = "default"
  subnetwork                 = "default"
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false
  create_service_account     = true
  ip_range_pods              = ""
  ip_range_services          = ""
  # Needed for pulling images from the GCR.
  grant_registry_access      = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

data "google_client_config" "default" {
}
