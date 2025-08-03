variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "jenkins-467900"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-f"
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "three-tier-k8s-gke-cluster"
}

variable "network_name" {
  description = "VPC Network Name"
  type        = string
  default     = "three-tier-vpc"
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "node_disk_size" {
  description = "Disk size for GKE nodes in GB"
  type        = number
  default     = 20
}

variable "min_nodes" {
  description = "Minimum number of nodes in node pool"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes in node pool"
  type        = number
  default     = 2
}

variable "initial_node_count" {
  description = "Initial number of nodes in node pool"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}