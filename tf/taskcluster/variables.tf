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

variable "rabbitmq_username" {
  type        = "string"
  description = "rabbitmq username"
}

variable "rabbitmq_password" {
  type        = "string"
  description = "rabbitmq password"
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

variable "github_integration_id" {
  type        = "string"
  description = "taskcluster-github app integration id."
}

variable "github_oauth_token" {
  type        = "string"
  description = "taskcluster-github app oauth token."
}

variable "github_private_pem" {
  type        = "string"
  description = "taskcluster-github private pem."
}

variable "github_webhook_secret" {
  type        = "string"
  description = "taskcluster-github webhook secret."
}
