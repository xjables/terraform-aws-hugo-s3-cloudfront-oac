terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.39.0" # Required by the S3 bucket refactor: https://www.hashicorp.com/blog/terraform-aws-provider-4-0-refactors-s3-bucket-resource
      configuration_aliases = [aws.virginia]
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}