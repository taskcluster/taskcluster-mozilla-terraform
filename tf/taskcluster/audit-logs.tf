/*
 * Temporary old-school setup for audit logs. We can remove
 * all of this once we do structured logging properly.
 * For now the architecture is that auth writes to aws_kinesis_stream
 * directly and then firehose pulls logs out of there and puts
 * them into s3.
 */

// This is the bucket where our audit logs end up
resource "aws_s3_bucket" "taskcluster_audit_logs" {
  bucket        = "${var.dpl}-audit-logs"
  force_destroy = true                    // TODO: This can be removed after all buckets are gone
}
