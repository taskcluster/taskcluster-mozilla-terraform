/*
* Many parts of this file are manually kept in sync because terraform root config can't
* use interpolation. If you are running this on a new account, you may need to comment out* the backend until after your first run.
*/

terraform {
  backend "s3" {
    bucket         = "taskcluster-tfstate"         # This must be in sync with tfstate_bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo" # This must be in sync with dynamodb_tfstate_lock
    key            = "taskcluster-staging"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "taskcluster-tfstate"
  region = "us-east-1"
  acl    = "private"

  versioning = {
    enabled = true
  }

  lifecycle_rule {
    id                                     = "cleanup-cruft"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}

resource "aws_dynamodb_table" "dynamodb_tfstate_lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
