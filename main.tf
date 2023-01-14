locals {
  # Side step the 'prefixed or suffixed slash' semantics by removing both and adding them where needed
  bucket_prefix = trim(var.bucket_prefix, "/")
  # A unique ID for identifying objects created by this module
  unique = substr(sha256(var.bucket_name), 0, 8)
}

data "aws_iam_policy_document" "hugo" {
  # Origin Access Control
  # See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
  statement {
    sid = "AllowCloudFrontServicePrincipalReadOnly"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/${local.bucket_prefix}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.hugo.arn]
    }
  }
}

resource "aws_s3_bucket" "hugo" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "hugo" {
  bucket = aws_s3_bucket.hugo.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "hugo" {
  bucket = aws_s3_bucket.hugo.id
  policy = data.aws_iam_policy_document.hugo.json
}

resource "aws_s3_bucket_website_configuration" "hugo" {
  bucket = aws_s3_bucket.hugo.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }

  routing_rule {
    condition {
      key_prefix_equals = "/"
    }
    redirect {
      replace_key_prefix_with = "index.html"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "hugo" {
  bucket = aws_s3_bucket.hugo.id

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

locals {
  hugo_origin_id      = "hugo-origin-s3"
  default_root_object = var.default_root_object != "" ? var.default_root_object : var.index_document
}

resource "aws_cloudfront_origin_access_control" "hugo" {
  name                              = local.hugo_origin_id
  description                       = "Access Control to hugo source bucket for ${local.hugo_origin_id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "hugo" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = local.default_root_object
  aliases             = var.aliases
  price_class         = var.cf_price_class

  origin {
    domain_name              = aws_s3_bucket.hugo.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.hugo.id
    origin_id                = local.hugo_origin_id
    origin_path              = "/${local.bucket_prefix}"
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.hugo_origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.cf_min_ttl
    default_ttl            = var.cf_default_ttl
    max_ttl                = var.cf_max_ttl

    dynamic "lambda_function_association" {
      for_each = var.pretty_urls ? [1] : []

      content {
        event_type   = "origin-request"
        lambda_arn   = aws_lambda_function.hugo_rewrite[0].qualified_arn
        include_body = true
      }

    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.hugo.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.minimum_viewer_tls_version
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
