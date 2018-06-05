provider "aws" {
  version             = "~> 1.15"
  region              = "${var.aws_region}"
  allowed_account_ids = ["${var.aws_account}"]
}

provider "google" {
  version = "~> 1.14"
  project = "${var.gce_project}"
  region  = "${var.gce_region}"
}

data "google_compute_zones" "in_region" {
  status = "UP"
}

resource "google_service_account" "kubernetes_cluster" {
  account_id   = "${var.kubernetes_cluster_name}-cluster-account"
  display_name = "Taskcluster Kubernetes cluster service account"
}

resource "google_project_iam_binding" "cluster_binding_logging" {
  members = ["serviceAccount:${google_service_account.kubernetes_cluster.email}"]
  role    = "roles/logging.logWriter"
}

resource "google_project_iam_binding" "cluster_binding_metrics" {
  members = ["serviceAccount:${google_service_account.kubernetes_cluster.email}"]
  role    = "roles/monitoring.metricWriter"
}

resource "google_project_iam_binding" "cluster_binding_monitoring" {
  members = ["serviceAccount:${google_service_account.kubernetes_cluster.email}"]
  role    = "roles/monitoring.viewer"
}

resource "google_container_cluster" "primary" {
  name               = "${var.kubernetes_cluster_name}"
  zone               = "${data.google_compute_zones.in_region.names.0}"
  initial_node_count = "${var.kubernetes_nodes_per_zone}"

  additional_zones = [
    "${data.google_compute_zones.in_region.names.1}",
    "${data.google_compute_zones.in_region.names.2}",
  ]

  # This is used to _turn off_ basic auth access to the masters
  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }
  }

  node_config {
    service_account = "${google_service_account.kubernetes_cluster.email}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
