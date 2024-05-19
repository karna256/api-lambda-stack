variable "lambda_names" {
  description = "Name of the lambda functions"
  type        = list(string)
}

variable "runtime" {
  description = "The runtime environment for the lambda function"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "The entry point for the lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}