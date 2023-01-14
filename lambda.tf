data "aws_iam_policy_document" "lambda_edge_assume" {
  provider = aws.virginia
  count = var.pretty_urls ? 1 : 0

  statement {
    sid = "AllowCFToAssume"
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "lambda_edge" {
  provider = aws.virginia
  count = var.pretty_urls ? 1 : 0

  name               = "lambda_edge_${local.unique}"
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_assume[0].json
}

data "archive_file" "hugo_rewrite" {
  count = var.pretty_urls ? 1 : 0

  type        = "zip"
  source_file = "${path.module}/lambda/rewrite_requests.py"
  output_path = "${path.module}/lambda/rewrite_requests.zip"
}

resource "aws_lambda_function" "hugo_rewrite" {
  provider = aws.virginia
  count = var.pretty_urls ? 1 : 0

  function_name    = "hugo_url_rewrite_${local.unique}"
  filename         = data.archive_file.hugo_rewrite[0].output_path
  role             = aws_iam_role.lambda_edge[0].arn
  handler          = "rewrite_requests.handler"
  runtime          = "python3.9"
  memory_size      = 128
  source_code_hash = data.archive_file.hugo_rewrite[0].output_base64sha256
  publish          = true

  environment {
    variables = {
      INDEX_DOCUMENT = var.index_document
    }
  }
}