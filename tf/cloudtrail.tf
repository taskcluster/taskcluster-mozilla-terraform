resource "aws_cloudtrail" "secops_trail" {
  count                 = "${var.secops_cloudtrail}"  # if secops_cloud_trail then ...
  name                  = "${var.dpl}-secops-trail"
  s3_bucket_name        = "${var.secops_cloudtrail_bucket}"
  s3_key_prefix         = "${var.dpl}/"
  is_multi_region_trail = true
}
