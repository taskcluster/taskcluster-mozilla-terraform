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

variable "gce_project" {
  type        = "string"
  description = "Project in Google Cloud."
}

variable "gce_region" {
  type        = "string"
  description = "Region in Google Cloud."
}

variable "kubernetes_cluster_name" {
  type        = "string"
  description = "Name of kubernetes cluster."
  default     = "taskcluster"
}

variable "kubernetes_nodes_per_zone" {
  type        = "string"
  description = "Number of kubernetes nodes per zone."
  default     = 1
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

