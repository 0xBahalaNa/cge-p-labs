output "cloudtrail_name" {
  description = "Name of the multi-region management CloudTrail"
  value       = aws_cloudtrail.mgmt.name
}

output "cloudtrail_bucket" {
  description = "S3 bucket receiving CloudTrail logs"
  value       = aws_s3_bucket.trail.id
}
