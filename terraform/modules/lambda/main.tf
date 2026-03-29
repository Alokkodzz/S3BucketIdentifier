variable "lambda_role_arn" {}
variable "queue_arn" {}
variable "source_bucket" {}

resource "aws_lambda_function" "router" {
  function_name = "ml-file-router"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = "${path.module}/../../lambda/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../../lambda/lambda.zip")

  timeout = 30
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.router.arn
  batch_size       = 5
}