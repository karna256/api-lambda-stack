data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "basic_logging" {
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role" "this" {
  name               = "lambda-basic-exec-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.basic_logging.arn
}

data "archive_file" "code" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "this" {
  count            = length(var.lambda_names)
  function_name    = var.lambda_names[count.index]
  filename         = "${path.module}/lambda_function_payload.zip"
  role             = aws_iam_role.this.arn
  runtime          = var.runtime
  handler          = var.handler
  source_code_hash = data.archive_file.code.output_base64sha256

  tags = {
    Name = var.lambda_names[count.index]
  }
}