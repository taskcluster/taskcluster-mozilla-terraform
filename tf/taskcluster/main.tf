module "taskcluster" {
  source                = "../../modules/taskcluster-terraform"
  prefix                = "${var.dpl}"
  aws_region            = "${var.aws_region}"
  azure_region          = "${var.azure_region}"
  gcp_project           = "${var.gcp_project}"
  root_url              = "${var.root_url}"
  root_url_tls_secret   = "taskcluster-ingress-tls-secret"
  rabbitmq_hostname     = "${var.rabbitmq_hostname}"
  rabbitmq_vhost        = "${rabbitmq_vhost.vhost.name}"
  disabled_services     = []
  cluster_name          = "${var.cluster_name}"
  notify_ses_arn        = "${var.notify_ses_arn}"
  irc_name              = "${var.irc_name}"
  irc_nick              = "${var.irc_nick}"
  irc_real_name         = "${var.irc_real_name}"
  irc_server            = "${var.irc_server}"
  irc_port              = "${var.irc_port}"
  irc_password          = "${var.irc_password}"
  github_integration_id = "${var.github_integration_id}"
  github_oauth_token    = "${var.github_oauth_token}"
  github_private_pem    = "${var.github_private_pem}"
  github_webhook_secret = "${var.github_webhook_secret}"
  audit_log_stream      = "${aws_kinesis_stream.taskcluster_audit_logs.arn}"
}
