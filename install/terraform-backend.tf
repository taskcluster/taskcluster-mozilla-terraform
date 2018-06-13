/*
 * This is all set up and configured in the `setup` configuration of this project.
 *
 * Many parts of this file are manually kept in sync because terraform root config can't
 * use interpolation. If you are running this on a new account, you may need to comment
 * out the backend until after your first run.
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
