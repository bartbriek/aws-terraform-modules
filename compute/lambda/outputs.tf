output "name" {
  value = aws_lambda_function.lambda.function_name
}

output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "iam_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "iam_role_name" {
  value = aws_iam_role.lambda_role.name
}
