// TODO: move this out of mozilla-taskcluster-terraform as it's a per-aws-account thing
resource "aws_cloudtrail" "secops_trail" {
  name                  = "secops_trail"
  s3_bucket_name        = "${var.secops_cloudtrail_bucket}"
  s3_key_prefix         = "${var.secops_cloudtrail_key_prefix}"
  is_multi_region_trail = true
}
