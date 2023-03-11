module "lambda_function" {
  source = "../../../compute/lambda"

  lambda_name = "<<FILL ME IN>>"
  account_id  = "<<FILL ME IN>>"
  environment = "<<FILL ME IN>>"
  region      = "<<FILL ME IN>>"
  kms_key_id  = "<<FILL ME IN>>"
}
