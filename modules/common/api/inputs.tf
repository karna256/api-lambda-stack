variable "lambda_arns" {
  description = "ARN of the Lambda function"
  type        = list(string)
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "api-gateway"
}

variable "lambda_invoke_arns" {
  description = "Invoke ARN of the Lambda function"
  type        = map(string)
}

variable "lambda_names" {
  description = "Name of the Lambda function"
  type        = list(string)
}