output "lambda_arns" {
  value       = [for i in aws_lambda_function.this : i.arn]
  description = "The ARNs of the Lambda functions"
}

output "lambda_names" {
  value       = [for i in aws_lambda_function.this : i.function_name]
  description = "The names of the Lambda functions"
}

output "lambda_invoke_arns" {
  value       = [for i in aws_lambda_function.this : i.invoke_arn]
  description = "The invoke ARNs of the Lambda functions"
}