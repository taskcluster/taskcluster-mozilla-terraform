resource "aws_cloudtrail" "secops_trail" {
  name                  = "secops_trail"
  s3_bucket_name        = "${var.secops_cloudtrail_bucket}"
  s3_key_prefix         = "mozilla-taskcluster-staging"
  is_multi_region_trail = true
}
