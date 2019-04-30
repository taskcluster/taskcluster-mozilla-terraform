variable "deployment" {
  description = "The name of the Taskcluster deployment"
}

variable "dpl" {
  description = "The shortened name of the Taskcluster deployment"
}

variable "cluster_name" {
  type        = "string"
  description = "Human readable cluster name"
}

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
}

variable "aws_account" {
  type        = "string"
  description = "The aws account you are operating on. Set this to avoid changing other accounts."
}

variable "azure_region" {
  type        = "string"
  description = "Region of azure storage."
}

variable "root_url" {
  type        = "string"
  description = "Taskcluster rootUrl."
}

variable "rabbitmq_hostname" {
  type        = "string"
  description = "rabbitmq hostname"
}

variable "rabbitmq_vhost" {
  type        = "string"
  description = "rabbitmq vhost"
}

variable "gcp_project" {
  type        = "string"
  description = "Project in Google Cloud."
}

variable "gcp_region" {
  type        = "string"
  description = "Region in Google Cloud."
}

variable "notify_ses_arn" {
  type        = "string"
  description = "arn of an ses address. This must be manually set up in aws."
}

variable "irc_name" {
  type        = "string"
  description = "username for irc bot."
}

variable "irc_nick" {
  type        = "string"
  description = "nick for irc bot."
}

variable "irc_real_name" {
  type        = "string"
  description = "real name for irc bot."
}

variable "irc_server" {
  type        = "string"
  description = "server for irc bot."
}

variable "irc_port" {
  type        = "string"
  description = "port for irc bot."
}

variable "irc_password" {
  type        = "string"
  description = "password for irc bot."
}

variable "github_app_id" {
  type        = "string"
  description = "taskcluster-github app id."
}

variable "github_private_pem" {
  type        = "string"
  description = "taskcluster-github private pem."
}

variable "github_webhook_secret" {
  type        = "string"
  description = "taskcluster-github webhook secret."
}

variable "gce_provider_gcp_project" {
  type        = "string"
  description = "Project in Google Cloud (used for gce_provider)."
}

variable "gce_provider_image_name" {
  type        = "string"
  description = "Image name to use for workers spawned by gce_provider."
}

variable "web_server_mozilla_auth0_domain" {
  type        = "string"
  description = "auth0 domain for mozilla-auth0 login strategy"
}

variable "web_server_mozilla_auth0_client_id" {
  type        = "string"
  description = "auth0 client id for mozilla-auth0 login strategy"
}

variable "web_server_mozilla_auth0_client_secret" {
  type        = "string"
  description = "auth0 client secret for mozilla-auth0 login strategy"
}

variable "web_server_mozilla_auth0_audience" {
  type        = "string"
  description = "auth0 audience for mozilla-auth0 login strategy"
}

variable "web_server_mozilla_auth0_scope" {
  type        = "string"
  description = "auth0 scope for mozilla-auth0 login strategy"
}

variable "web_server_github_client_id" {
  type        = "string"
  description = "github client id for mozilla-auth0 login strategy"
}

variable "web_server_github_client_secret" {
  type        = "string"
  description = "github client secret for mozilla-auth0 login strategy"
}
