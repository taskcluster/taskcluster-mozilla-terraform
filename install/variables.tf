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

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-east-1"
}

variable "aws_account" {
  type        = "string"
  description = "The aws account you are operating on. Set this to avoid changing other accounts."
}

variable "taskcluster_bucket_prefix" {
  type        = "string"
  description = "The prefix of all s3 buckets needed for a taskcluster cluster to function."
}

variable "azure_resource_group_name" {
  type        = "string"
  description = "Name of azure storage resource group."
}

variable "azure_region" {
  type        = "string"
  description = "Region of azure storage."
}

variable "taskcluster_staging_root_url" {
  type        = "string"
  description = "Taskcluster rootUrl."
}

variable "taskcluster_staging_crt" {
  type        = "string"
  description = "Taskcluster staging tls certificate."
}

variable "taskcluster_staging_key" {
  type        = "string"
  description = "Taskcluster staging tls private key."
}

variable "acme_challenge_key" {
  type        = "string"
  description = "acme challenge key in path (for letsencrypt)"
}

variable "acme_challenge_value" {
  type        = "string"
  description = "acme challenge value served with 200 (for letsencrypt)"
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

variable "gce_project" {
  type        = "string"
  description = "Project in Google Cloud."
}

variable "gce_region" {
  type        = "string"
  description = "Region in Google Cloud."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

