###################################################################################
# IAM
###################################################################################
resource "aws_iam_role" "lambda_role" {
  name = "${title(var.environment)}${title(var.lambda_name)}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "LambdaServiceAssumePermission"
          Effect = "Allow",
          Action = "sts:AssumeRole",
          Principal = {
            Service = "lambda.amazonaws.com"
          },
        }
      ]
    }
  )
}

###################################################################################
# LAMBDA
###################################################################################
resource "aws_lambda_function" "lambda" {
  function_name = "${title(var.environment)}${title(var.lambda_name)}"
  filename      = "${path.module}/dummy.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  memory_size   = var.lambda_memory
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  architectures = var.lambda_architectures
  layers        = var.lambda_layers

  tracing_config {
    mode = "Active"
  }

  tags = {
    Name = "${title(var.environment)}${title(var.lambda_name)}"
  }

  environment {
    variables = {
      Environment                  = var.environment
      Region                       = var.region
      POWERTOOLS_METRICS_NAMESPACE = var.environment
    }
  }

  lifecycle {
    ignore_changes = [
      layers
    ]
  }
}

###################################################################################
# CLOUDWATCH
###################################################################################
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.log_retention_period
  kms_key_id        = var.kms_key_id
}

resource "aws_iam_policy" "lambda_logging" {
  name = "${aws_lambda_function.lambda.function_name}Cloudwatch"
  policy = jsonencode(
    { #tfsec:ignore:aws-iam-no-policy-wildcards
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "CloudwatchLoggingPermissions"
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = [
            aws_cloudwatch_log_group.log_group.arn,
            "${aws_cloudwatch_log_group.log_group.arn}:*"
          ]
        },
        {
          Sid    = "XrayLoggingPermissions"
          Effect = "Allow"
          Action = [
            "xray:PutTraceSegments",
            "xray:PutTelemetryRecords",
            "xray:GetSamplingRules",
            "xray:GetSamplingTargets",
            "xray:GetSamplingStatisticSummaries"
          ]
          Resource = "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
