variable "lambda_role_arn" {}
variable "queue_arn" {}
variable "source_bucket" {}


//data "archive_file" "python_lambda_package" {  
//  type = "zip"  
//  source_file = "${path.module}/python/lambda_function.py" 
//  output_path = "${path.module}/python/s3_BucketIdentifier.zip"
//}

resource "aws_lambda_function" "router" {
  function_name = "ml-file-router"
  role          = var.lambda_role_arn
  package_type  = "Image"

  image_uri = "736395454781.dkr.ecr.ap-south-1.amazonaws.com/ml-file-router:latest"

  timeout = 120
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.router.arn
  batch_size       = 5
}