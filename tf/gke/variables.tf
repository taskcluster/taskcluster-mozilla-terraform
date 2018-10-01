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
