module "lambdas" {
  source       = "./modules/common/lambda"
  lambda_names = ["ankit-tf-lambda-1", "ankit-tf-lambda-2"]
}

module "api" {
  source             = "./modules/common/api"
  lambda_arns        = module.lambdas.lambda_arns
  api_name           = "api-gateway-test"
  lambda_invoke_arns = { for name in module.lambdas.lambda_names : name => lookup(module.lambdas.lambda_invoke_arns, name) }
  lambda_names       = module.lambdas.lambda_names
}