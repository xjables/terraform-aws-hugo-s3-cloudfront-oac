// Provider vars for authentication
variable "aliases" {
  type        = list(string)
  description = "List of hostnames the site should used. e.g. [\"example.com\", \"www.example.com\"]"
}

variable "bucket_name" {
  type        = string
  description = "The S3 bucket to be created into which your site will data will be written."
}

variable "bucket_prefix" {
  type        = string
  description = "Path in S3 bucket acting as the site origin."
  default     = "public"
}

variable "pretty_urls" {
  type        = bool
  description = "If you are using pretty urls (default behavior in Hugo) leave this as true, otherwise, if using ugly urls, set this to false."
  default     = true
}

variable "cert_domain" {
  type        = string
  description = "Domain name to use for ACM certificate. If this module does not create the certificate, it must already exist in us-east-1."
}

variable "create_cert" {
  type        = bool
  description = "Whether or not this module should create the certificate or look it up."
  default     = false
}

variable "cert_SNIs" {
  type        = list(string)
  description = "A list of Subject Alternative Names to include on the certificate if it is being created by this module. Not used if `create_cert` is false."
  default     = []
}

variable "route53_zone" {
  type        = string
  description = "The zone name in which to create the DNS validation records for the ACM certificate. Defaults to the `cert_domain` variable. Not used if `create_cert` is false."
  default     = ""
}

variable "cf_default_ttl" {
  type        = string
  description = "CloudFront default TTL for cachine"
  default     = "86400"
}

variable "cf_min_ttl" {
  type        = string
  description = "CloudFront minimum TTL for caching"
  default     = "0"
}

variable "cf_max_ttl" {
  type        = string
  description = "CloudFront maximum TTL for caching"
  default     = "31536000"
}

variable "cf_price_class" {
  type        = string
  description = "CloudFront price class"
  default     = "PriceClass_All"
}

variable "cors_allowed_headers" {
  type        = list(string)
  description = "List of headers allowed in CORS"
  default     = []
}

variable "cors_allowed_methods" {
  type        = list(string)
  description = "List of methods allowed in CORS"
  default     = ["GET"]
}

variable "cors_allowed_origins" {
  type        = list(string)
  description = "List of origins allowed to make CORS requests"
  default     = ["https://s3.amazonaws.com"]
}

variable "cors_expose_headers" {
  type        = list(string)
  description = "List of headers to expose in CORS response"
  default     = []
}

variable "cors_max_age_seconds" {
  type        = string
  description = "Specifies time in seconds that browser can cache the response for a preflight request"
  default     = 3000
}

variable "custom_error_response" {
  type = set(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  description = "Optionally a list of custom error response configurations for CloudFront distribution"
  default     = []
}

variable "default_root_object" {
  type        = string
  description = "This value defaults to the `var.index_document`."
  default     = ""
}

variable "error_document" {
  type        = string
  description = "Error page document in S3 bucket"
  default     = "404.html"
}

variable "index_document" {
  type        = string
  description = "The index document used as the root document for each sub-path on the site."
  default     = "index.html"
}

variable "minimum_viewer_tls_version" {
  type        = string
  description = "Minimum TLS version for viewers connecting to CloudFront"
  default     = "TLSv1.2_2019"
}

variable "origin_ssl_protocols" {
  type        = list(string)
  description = "List of Origin SSL policies for Cloudfront distribution. See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValues-security-policy for options"
  default     = ["TLSv1.2"]
}

variable "routing_rules" {
  type        = string
  description = "A json array containing routing rules describing redirect behavior and when redirects are applied"

  default = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "/"
    },
    "Redirect": {
        "ReplaceKeyWith": "index.html"
    }
}]
EOF
}

variable "viewer_protocol_policy" {
  type        = string
  description = "Types of http request. One of the following values: `allow-all`, `https-only`, or `redirect-to-https`"
  default     = "redirect-to-https"

  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "'viewer_protocol_policy' must be one of the following: allow-all, https-only, or redirect-to-https."
  }
}

variable "deployment_user_arn" {
  type        = string
  description = "ARN for user who is able to put objects into S3 bucket"
}
