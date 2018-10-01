/*
 * Temporary old-school setup for audit logs. We can remove
 * all of this once we do structured logging properly.
 * For now the architecture is that auth writes to aws_kinesis_stream
 * directly and then firehose pulls logs out of there and puts
 * them into s3.
 */

// The following 2 cloudwatch resources are for error reporting
// from the firehose directly
resource "aws_cloudwatch_log_group" "taskcluster_audit_logs" {
  name = "/aws/kinesisfirehose/${var.dpl}-audit-logs"
}

resource "aws_cloudwatch_log_stream" "taskcluster_audit_logs" {
  name           = "S3Delivery"
  log_group_name = "${aws_cloudwatch_log_group.taskcluster_audit_logs.name}"
}

// This is the bucket where our audit logs end up
resource "aws_s3_bucket" "taskcluster_audit_logs" {
  bucket = "${var.dpl}-audit-logs"
}

// The auth service writes to this kinesis stream directly
// Our firehose pulls logs out of here and stuffs them in s3.
// In addition, other teams at mozilla can pull logs off
// and stuff them into whatever services they have to use
// audit logs.
resource "aws_kinesis_stream" "taskcluster_audit_logs" {
  name             = "${var.dpl}-audit-logs"
  shard_count      = 1
  retention_period = 24
}

// This is required to allow firehose to read our kinesis streams
resource "aws_iam_role" "taskcluster_audit_logs_firehose" {
  name = "${var.dpl}-audit-log-firehose-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.aws_account}"
        }
      }
    } ]
}
EOF
}

// This policy allows firehose to log errors in addition to read
// from kinesis and put them into s3
resource "aws_iam_role_policy" "taskcluster_audit_logs_firehose" {
  name = "${var.dpl}-audit-logs-firehose"
  role = "${aws_iam_role.taskcluster_audit_logs_firehose.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.taskcluster_audit_logs.arn}",
                "${aws_s3_bucket.taskcluster_audit_logs.arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords"
            ],
            "Resource": "${aws_kinesis_stream.taskcluster_audit_logs.arn}"
        },
        {
           "Effect": "Allow",
           "Action": [
               "logs:PutLogEvents"
           ],
           "Resource": [
             "${aws_cloudwatch_log_stream.taskcluster_audit_logs.arn}"
           ]
        }
    ]
}
EOF
}

// The firehose itself. This just reads logs out of kinesis
// and puts them in s3
resource "aws_kinesis_firehose_delivery_stream" "taskcluster_audit_logs_firehose" {
  name        = "${var.dpl}-audit-logs"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = "${aws_kinesis_stream.taskcluster_audit_logs.arn}"
    role_arn = "${aws_iam_role.taskcluster_audit_logs_firehose.arn}"
  }

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.taskcluster_audit_logs_firehose.arn}"
    bucket_arn = "${aws_s3_bucket.taskcluster_audit_logs.arn}"
    prefix     = "audit-logs"

    cloudwatch_logging_options = {
      enabled         = true
      log_group_name  = "${aws_cloudwatch_log_group.taskcluster_audit_logs.name}"
      log_stream_name = "${aws_cloudwatch_log_stream.taskcluster_audit_logs.name}"
    }
  }
}
