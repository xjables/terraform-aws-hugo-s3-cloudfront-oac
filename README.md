## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_policy.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_acm_certificate.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_iam_policy_document.hugo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | List of hostnames the site should used. e.g. ["example.com", "www.example.com"] | `list(string)` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The S3 bucket to be created into which your site will data will be written. | `string` | n/a | yes |
| <a name="input_cert_domain"></a> [cert\_domain](#input\_cert\_domain) | Domain name to use for ACM certificate. If this module does not create the certificate, it must already exist in us-east-1. | `string` | n/a | yes |
| <a name="input_deployment_user_arn"></a> [deployment\_user\_arn](#input\_deployment\_user\_arn) | ARN for user who is able to put objects into S3 bucket | `string` | n/a | yes |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Path in S3 bucket acting as the site origin. | `string` | `"public"` | no |
| <a name="input_cert_SNIs"></a> [cert\_SNIs](#input\_cert\_SNIs) | A list of Subject Alternative Names to include on the certificate if it is being created by this module. Not used if `create_cert` is false. | `list(string)` | `[]` | no |
| <a name="input_cf_default_ttl"></a> [cf\_default\_ttl](#input\_cf\_default\_ttl) | CloudFront default TTL for cachine | `string` | `"86400"` | no |
| <a name="input_cf_max_ttl"></a> [cf\_max\_ttl](#input\_cf\_max\_ttl) | CloudFront maximum TTL for caching | `string` | `"31536000"` | no |
| <a name="input_cf_min_ttl"></a> [cf\_min\_ttl](#input\_cf\_min\_ttl) | CloudFront minimum TTL for caching | `string` | `"0"` | no |
| <a name="input_cf_price_class"></a> [cf\_price\_class](#input\_cf\_price\_class) | CloudFront price class | `string` | `"PriceClass_All"` | no |
| <a name="input_cors_allowed_headers"></a> [cors\_allowed\_headers](#input\_cors\_allowed\_headers) | List of headers allowed in CORS | `list(string)` | `[]` | no |
| <a name="input_cors_allowed_methods"></a> [cors\_allowed\_methods](#input\_cors\_allowed\_methods) | List of methods allowed in CORS | `list(string)` | <pre>[<br>  "GET"<br>]</pre> | no |
| <a name="input_cors_allowed_origins"></a> [cors\_allowed\_origins](#input\_cors\_allowed\_origins) | List of origins allowed to make CORS requests | `list(string)` | <pre>[<br>  "https://s3.amazonaws.com"<br>]</pre> | no |
| <a name="input_cors_expose_headers"></a> [cors\_expose\_headers](#input\_cors\_expose\_headers) | List of headers to expose in CORS response | `list(string)` | `[]` | no |
| <a name="input_cors_max_age_seconds"></a> [cors\_max\_age\_seconds](#input\_cors\_max\_age\_seconds) | Specifies time in seconds that browser can cache the response for a preflight request | `string` | `3000` | no |
| <a name="input_create_cert"></a> [create\_cert](#input\_create\_cert) | Whether or not this module should create the certificate or look it up. | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | Optionally a list of custom error response configurations for CloudFront distribution | <pre>set(object({<br>    error_code         = number<br>    response_code      = number<br>    response_page_path = string<br>  }))</pre> | `[]` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | CloudFront distribution default\_root\_object | `string` | `"index.html"` | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | Error page document in S3 bucket | `string` | `"404.html"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | Index page document in S3 bucket | `string` | `"index.html"` | no |
| <a name="input_minimum_viewer_tls_version"></a> [minimum\_viewer\_tls\_version](#input\_minimum\_viewer\_tls\_version) | Minimum TLS version for viewers connecting to CloudFront | `string` | `"TLSv1.2_2019"` | no |
| <a name="input_origin_ssl_protocols"></a> [origin\_ssl\_protocols](#input\_origin\_ssl\_protocols) | List of Origin SSL policies for Cloudfront distribution. See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValues-security-policy for options | `list(string)` | <pre>[<br>  "TLSv1.2"<br>]</pre> | no |
| <a name="input_route53_zone"></a> [route53\_zone](#input\_route53\_zone) | The zone name in which to create the DNS validation records for the ACM certificate. Defaults to the `cert_domain` variable. Not used if `create_cert` is false. | `string` | `""` | no |
| <a name="input_routing_rules"></a> [routing\_rules](#input\_routing\_rules) | A json array containing routing rules describing redirect behavior and when redirects are applied | `string` | `"[{\n    \"Condition\": {\n        \"KeyPrefixEquals\": \"/\"\n    },\n    \"Redirect\": {\n        \"ReplaceKeyWith\": \"index.html\"\n    }\n}]\n"` | no |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | Types of http request. One of the following values: `allow-all`, `https-only`, or `redirect-to-https` | `string` | `"redirect-to-https"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | n/a |
| <a name="output_acm_certificate_id"></a> [acm\_certificate\_id](#output\_acm\_certificate\_id) | n/a |
| <a name="output_cloudfront_hostname"></a> [cloudfront\_hostname](#output\_cloudfront\_hostname) | n/a |
| <a name="output_cloudfront_zone_id"></a> [cloudfront\_zone\_id](#output\_cloudfront\_zone\_id) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | n/a |
| <a name="output_s3_bucket_code_uri_path"></a> [s3\_bucket\_code\_uri\_path](#output\_s3\_bucket\_code\_uri\_path) | n/a |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | n/a |
