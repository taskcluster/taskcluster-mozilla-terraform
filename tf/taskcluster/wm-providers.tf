resource "google_service_account" "wm" {
  account_id = "worker-manager"
}

resource "google_project_iam_member" "worker_manager_role_accounts" {
  role   = "roles/iam.serviceAccountAdmin"
  member = "serviceAccount:${google_service_account.wm.email}"
}

resource "google_project_iam_member" "worker_manager_role_roles" {
  role   = "roles/iam.roleAdmin"
  member = "serviceAccount:${google_service_account.wm.email}"
}

resource "google_project_iam_member" "worker_manager_role_policies" {
  role   = "roles/resourcemanager.projectIamAdmin"
  member = "serviceAccount:${google_service_account.wm.email}"
}

// Need more than instanceAdmin in order to delete operations
resource "google_project_iam_member" "worker_manager_role_instances" {
  role   = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.wm.email}"
}

resource "google_service_account_key" "wm-key" {
  service_account_id = "${google_service_account.wm.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

locals {
  wm_providers = {
    google = {
      providerType        = "google"
      project             = "${var.gcp_project}"
      instancePermissions = ["logging.logEntries.create"]
      creds               = "${google_service_account_key.wm-key.private_key}"
    }
  }
}
