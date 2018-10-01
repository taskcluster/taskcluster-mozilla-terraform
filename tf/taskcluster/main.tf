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
  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"
}

provider "k8s" {}

provider "rabbitmq" {
  version  = "~> 1.0"
  endpoint = "https://${var.rabbitmq_hostname}"
  username = "${var.rabbitmq_username}"
  password = "${var.rabbitmq_password}"
}

module "taskcluster" {
  source                    = "../../modules/taskcluster-terraform"
  prefix                    = "${var.dpl}"
  azure_region              = "${var.azure_region}"
  root_url                  = "${var.root_url}"
  rabbitmq_hostname         = "${var.rabbitmq_hostname}"
  rabbitmq_vhost            = "${var.rabbitmq_vhost}"
  disabled_services         = ["taskcluster-ping"]
  cluster_name              = "${var.cluster_name}"
  notify_ses_arn            = "${var.notify_ses_arn}"
  irc_name                  = "${var.irc_name}"
  irc_nick                  = "${var.irc_nick}"
  irc_real_name             = "${var.irc_real_name}"
  irc_server                = "${var.irc_server}"
  irc_port                  = "${var.irc_port}"
  irc_password              = "${var.irc_password}"
  github_integration_id     = "${var.github_integration_id}"
  github_oauth_token        = "${var.github_oauth_token}"
  github_private_pem        = "${var.github_private_pem}"
  github_webhook_secret     = "${var.github_webhook_secret}"
  audit_log_stream          = "${aws_kinesis_stream.taskcluster_audit_logs.arn}"
}
