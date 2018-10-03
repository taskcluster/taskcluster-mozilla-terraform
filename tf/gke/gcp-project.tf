resource "google_project" "project" {
  name            = "${var.gcp_project}"
  project_id      = "${var.gcp_project}"
  folder_id       = "${var.gcp_folder_id}"
  billing_account = "${var.gcp_billing_account_id}"
}

resource "google_project_service" "project_compute" {
  project = "${google_project.project.id}"
  service = "compute.googleapis.com"
}

resource "google_project_service" "project_log" {
  project = "${google_project.project.id}"
  service = "logging.googleapis.com"
}

resource "google_project_service" "project_monitor" {
  project = "${google_project.project.id}"
  service = "monitoring.googleapis.com"
}

resource "google_project_service" "project_kube" {
  project = "${google_project.project.id}"
  service = "container.googleapis.com"
}

resource "google_project_service" "project_iam" {
  project = "${google_project.project.id}"
  service = "iam.googleapis.com"
}

resource "google_project_service" "project_resources" {
  project = "${google_project.project.id}"
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_service_account" "kubernetes_cluster" {
  project      = "${google_project.project.id}"
  account_id   = "${var.kubernetes_cluster_name}-kube"
  display_name = "Taskcluster Kubernetes cluster service account"
  depends_on   = ["google_project_service.project_kube"]
}

resource "google_project_iam_member" "cluster_binding_logging" {
  project = "${google_project.project.id}"
  member  = "serviceAccount:${google_service_account.kubernetes_cluster.email}"
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_member" "cluster_binding_metrics" {
  project = "${google_project.project.id}"
  member  = "serviceAccount:${google_service_account.kubernetes_cluster.email}"
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_member" "cluster_binding_monitoring" {
  project = "${google_project.project.id}"
  member  = "serviceAccount:${google_service_account.kubernetes_cluster.email}"
  role    = "roles/monitoring.viewer"
}
