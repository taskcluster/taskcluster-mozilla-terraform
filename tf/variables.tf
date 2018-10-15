# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "deployment" {
  description = "The name of the Taskcluster deployment"
}

variable "dpl" {
  description = "The shortened name of the Taskcluster deployment"
}

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
}

variable "aws_account" {
  type        = "string"
  description = "The aws account you are operating on. Set this to avoid changing other accounts."
}

variable "gcp_folder_id" {
  type        = "string"
  description = "Numeric ID of the folder in which to create the GCP project."

  // NOTE: available under IAM & admin -> settings; copy out of the URL as the field itself
  // is un-copyable
}

variable "gcp_billing_account_id" {
  type        = "string"
  description = "Billing account this project should bill to"
}

variable "gcp_project" {
  type        = "string"
  description = "Project in Google Cloud."
}

variable "gcp_region" {
  type        = "string"
  description = "Region in Google Cloud."
}

variable "kubernetes_cluster_name" {
  type        = "string"
  description = "Name of kubernetes cluster."
}

variable "kubernetes_nodes" {
  type        = "string"
  description = "Number of kubernetes nodes in the cluster."
}

variable "secops_cloudtrail" {
  type        = "string"
  description = "True if this deployment should log to secops' cloudtrail bucket (requiring extra configuration)."
}

variable "secops_cloudtrail_bucket" {
  type        = "string"
  description = "Bucket to which we send cloudtrail logs for secops.  This bucket belongs to secops, not this AWS account.  Only used if secops_cloud_trail is 1."
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

variable "rabbitmq_admin_username" {
  type        = "string"
  description = "rabbitmq username for an administrative user"
}

variable "rabbitmq_password" {
  type        = "string"
  description = "rabbitmq password"
}

variable "notify_ses_arn" {
  type        = "string"
  description = "arn of an ses address. This must be manually set up in aws."
}

variable "cluster_name" {
  type        = "string"
  description = "Human readable cluster name"
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
