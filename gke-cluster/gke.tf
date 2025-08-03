# GKE Cluster
resource "google_container_cluster" "primary" {
  provider = google-beta
  
  name     = var.cluster_name
  location = var.zone
  
  # Network configuration
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.gke_subnet.name
  
  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
  
  # IP allocation policy for VPC-native cluster
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }
  
  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.4.0.0/28"
    
    master_global_access_config {
      enabled = true
    }
  }
  
  # Master authorized networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "All networks"
    }
  }
  
  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    
    horizontal_pod_autoscaling {
      disabled = false
    }
    
    network_policy_config {
      disabled = false
    }
    
    dns_cache_config {
      enabled = true
    }
  }
  
  # Network policy
  network_policy {
    enabled = true
  }
  

  
  # Release channel
  release_channel {
    channel = "STABLE"
  }
  
  # Security and compliance
  enable_shielded_nodes = true
  
  # Resource labels
  resource_labels = {
    environment = var.environment
    project     = "three-tier-app"
    managed-by  = "terraform"
  }
  
  depends_on = [
    google_project_service.required_apis,
    google_compute_subnetwork.gke_subnet,
    google_service_account.gke_sa
  ]
}

# Primary Node Pool
resource "google_container_node_pool" "primary_nodes" {
  provider = google-beta
  
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  # Autoscaling configuration
  initial_node_count = var.initial_node_count
  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }
  
  # Node configuration
  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = var.node_disk_size
    disk_type    = "pd-ssd"
    
    # Service account
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    # Security
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
    
    # Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    
    # Labels and tags
    labels = {
      role        = "worker"
      environment = var.environment
      node-pool   = "primary"
    }
    
    tags = ["gke-node", "${var.cluster_name}-node"]
    
    # Metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  
  # Management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  
  # Upgrade settings
  upgrade_settings {
    strategy        = "SURGE"
    max_surge       = 1
    max_unavailable = 0
  }
  
  depends_on = [google_container_cluster.primary]
}