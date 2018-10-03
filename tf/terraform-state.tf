resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "${var.dpl}-tfstate"
  region = "${var.aws_region}"
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
  name           = "${var.dpl}-tfstate"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
