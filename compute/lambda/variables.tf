###################################################################################
# REQUIRED VARIABLES
###################################################################################
variable "lambda_name" {
  description = "Name of the lambda, will be prefixed with the environment"
  type        = string
}

variable "account_id" {
  description = "Account id where the lambda is deployed in"
  type        = string
}

variable "environment" {
  description = "Environment the lambda will be used in"
  type        = string
}

variable "region" {
  description = "AWS Region lambda is deployed in"
  type        = string
}

variable "kms_key_id" {
  description = "KMS Key Id that encrypts the cloudwatch loggroups"
  type        = string
}

###################################################################################
# OPTIONAL VARIABLES
###################################################################################
variable "lambda_handler" {
  description = "Name of the function and reference to the handler function"
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Runtime of the lambda"
  type        = string
  default     = "python3.8"
}

variable "lambda_memory" {
  description = "Memory the lambda can consume"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Duration in seconds that the lambda can run"
  type        = number
  default     = 60
}

variable "lambda_architectures" {
  description = "Architecture that the lambda is using"
  type        = list(string)
  default     = ["arm64"]
}

variable "lambda_layers" {
  description = "Layer arns that need to be attached to the lambda"
  type        = list(string)
  default     = []
}

variabel "log_retention_period" {
  description = "The amount of days the cloudwatch logs need to be perserved"
  type        = number
  default     = 7
}
