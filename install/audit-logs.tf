resource "aws_s3_bucket" "taskcluster_audit_logs" {
  bucket = "taskcluster-staging-audit-logs"
}

resource "aws_kinesis_stream" "taskcluster_audit_logs" {
  name             = "taskcluster-staging-audit-logs"
  shard_count      = 1
  retention_period = 24
}

resource "aws_iam_role" "taskcluster_audit_logs_firehose" {
  name = "taskcluster-audit-log-firehose-role"

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

resource "aws_iam_role_policy" "taskcluster_audit_logs_firehose" {
  name = "taskcluster-audit-logs-firehose"
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
               "arn:aws:logs:*:${var.aws_account}:log-group:/aws/kinesisfirehose/taskcluster-audit-logs:log-stream:*"
           ]
        }
    ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "taskcluster_audit_logs_firehose" {
  name        = "taskcluster-audit-logs"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = "${aws_iam_role.taskcluster_audit_logs_firehose.arn}"
    bucket_arn = "${aws_s3_bucket.taskcluster_audit_logs.arn}"
    prefix     = "auth-audit-logs"

    cloudwatch_logging_options = {
      enabled = true
    }
  }
}
