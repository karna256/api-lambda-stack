resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
  tags = {
    Name = var.api_name
  }
}

resource "aws_apigatewayv2_integration" "this" {
  for_each             = var.lambda_invoke_arns
  api_id               = aws_apigatewayv2_api.this.id
  integration_type     = "AWS_PROXY"
  integration_uri      = each.value
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "this" {
  for_each  = toset(var.lambda_names)
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /${each.value}"
  target    = "integrations/${aws_apigatewayv2_integration.this[each.value].id}"
}


resource "aws_lambda_permission" "this" {
  for_each      = toset(var.lambda_names)
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}