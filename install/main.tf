provider "aws" {
  version             = "~> 1.15"
  region              = "${var.aws_region}"
  allowed_account_ids = ["${var.aws_account}"]
}

provider "azurerm" {
  version = "~> 1.3.3"
}

provider "google" {
  version = "~> 1.17.1"
  project = "${var.gce_project}"
  region  = "${var.gce_region}"
}

provider "k8s" {}

provider "rabbitmq" {
  version  = "~> 1.0"
  endpoint = "https://${var.rabbitmq_hostname}"
  username = "${var.rabbitmq_username}"
  password = "${var.rabbitmq_password}"
}

module "taskcluster" {
  source                    = "../modules/taskcluster-terraform"
  bucket_prefix             = "${var.taskcluster_bucket_prefix}"
  azure_resource_group_name = "${var.azure_resource_group_name}"
  azure_region              = "${var.azure_region}"
  root_url                  = "${var.taskcluster_staging_root_url}"
  rabbitmq_hostname         = "${var.rabbitmq_hostname}"
  rabbitmq_vhost            = "${var.rabbitmq_vhost}"
  disabled_services         = ["taskcluster-ping"]
  cluster_name              = "Taskcluster Staging"
}
