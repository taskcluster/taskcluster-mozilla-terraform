provider "aws" {
  version             = "~> 1.15"
  region              = "${var.aws_region}"
  allowed_account_ids = ["${var.aws_account}"]
}

provider "google" {
  version = "~> 1.17.1"
  region  = "${var.gcp_region}"
}

provider "k8s" {}

provider "jsone" {}
