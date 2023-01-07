terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0.0" # Required by the S3 bucket refactor: https://www.hashicorp.com/blog/terraform-aws-provider-4-0-refactors-s3-bucket-resource
      configuration_aliases = [aws.source, aws.virginia]
    }
  }
}