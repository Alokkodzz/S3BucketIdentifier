provider "aws" {
  region = "ap-southeast-2"
}

module "s3" {
  source = "./modules/s3"
}

module "sqs" {
  source = "./modules/sqs"
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"

  lambda_role_arn = module.iam.lambda_role_arn
  queue_arn       = module.sqs.queue_arn
  source_bucket   = module.s3.source_bucket
}

# Connect S3 → SQS
resource "aws_s3_bucket_notification" "s3_to_sqs" {
  bucket = module.s3.source_bucket

  queue {
    queue_arn = module.sqs.queue_arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [module.sqs]
}