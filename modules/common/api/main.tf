resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
  tags = {
    Name = var.api_name
  }
}

resource "aws_apigatewayv2_integration" "this" {
  count = length(var.lambda_arns)
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_invoke_arns[count.index]
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "this" {
  count = length(var.lambda_arns)
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /${var.lambda_names[count.index]}"
  target    = "integrations/${aws_apigatewayv2_integration.this[count.index].id}"
}


resource "aws_lambda_permission" "this" {
  count         = length(var.lambda_invoke_arns)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_names[count.index]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "$default"
  auto_deploy = true
}