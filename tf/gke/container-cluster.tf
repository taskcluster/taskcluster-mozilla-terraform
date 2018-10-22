data "jsone_template" "admin_bindings" {
  template = "${file("${path.module}/admin_bindings.yaml")}"

  yaml_context = "${jsonencode(map(
    "team_members", "${local.team_members}"
  ))}"
}

resource "google_container_cluster" "primary" {
  project = "${google_project.project.id}"

  depends_on = [
    "google_project_service.project_kube",
    "google_project_service.project_log",
    "google_project_service.project_monitor",
  ]

  name   = "${var.kubernetes_cluster_name}"
  region = "${var.gcp_region}"

  min_master_version = "1.10"

  node_pool = [
    {
      name       = "${var.kubernetes_cluster_name}-primary"
      node_count = "${var.kubernetes_nodes}"

      management {
        auto_repair  = true
        auto_upgrade = true
      }

      node_config {
        machine_type    = "${var.kubernetes_node_type}"
        service_account = "${google_service_account.kubernetes_cluster.email}"

        oauth_scopes = [
          "https://www.googleapis.com/auth/compute",
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
        ]
      }
    },
  ]

  # This is used to _turn off_ basic auth access to the masters
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }
  }

  // enable later terraform invocations of kubectl to work when this is first created
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.kubernetes_cluster_name} --project ${google_project.project.id} --region ${var.gcp_region}"
  }
}

resource "k8s_manifest" "admin_bindings" {
  depends_on = ["google_container_cluster.primary"]
  content    = "${data.jsone_template.admin_bindings.rendered}"
}
