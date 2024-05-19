module "lambdas" {
  source       = "./modules/common/lambda"
  lambda_names = ["ankit-tf-lambda-1", "ankit-tf-lambda-2"]
}
