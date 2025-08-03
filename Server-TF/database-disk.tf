resource "google_compute_disk" "database_disk" {
  name = var.pv_disk_name
  type = "pd-standard"
  zone = "us-central1-f"
  size = var.pv_disk_size
}