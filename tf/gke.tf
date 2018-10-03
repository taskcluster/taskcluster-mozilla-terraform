module "gke" {
  source = "./gke"

  deployment              = "${var.deployment}"
  dpl                     = "${var.dpl}"
  gcp_folder_id           = "${var.gcp_folder_id}"
  gcp_region              = "${var.gcp_region}"
  gcp_billing_account_id  = "${var.gcp_billing_account_id}"
  gcp_project             = "${var.gcp_project}"
  aws_region              = "${var.aws_region}"
  aws_account             = "${var.aws_account}"
  kubernetes_cluster_name = "${var.kubernetes_cluster_name}"
  kubernetes_nodes        = "${var.kubernetes_nodes}"
}
