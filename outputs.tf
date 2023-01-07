output "acm_certificate_id" {
  value = data.aws_acm_certificate.hugo.id
}

output "acm_certificate_arn" {
  value = data.aws_acm_certificate.hugo.arn
}

output "cloudfront_hostname" {
  value = aws_cloudfront_distribution.hugo.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.hugo.hosted_zone_id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.hugo.id
}

output "s3_bucket_code_uri_path" {
  value = "s3://${aws_s3_bucket.hugo.id}/${var.bucket_prefix}"
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.hugo.arn
}
