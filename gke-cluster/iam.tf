# Service Account for GKE nodes
resource "google_service_account" "gke_sa" {
  account_id   = "three-tier-gke-sa"
  display_name = "GKE Service Account for ${var.cluster_name}"
  description  = "Service account for GKE cluster nodes"
}

# IAM bindings for the service account
resource "google_project_iam_member" "gke_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# Additional service account for Workload Identity (if needed)
resource "google_service_account" "workload_identity_sa" {
  account_id   = "three-tier-wi-sa"
  display_name = "Workload Identity SA for ${var.cluster_name}"
  description  = "Service account for Workload Identity"
}