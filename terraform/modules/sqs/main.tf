resource "aws_sqs_queue" "dlq" {
  name = "ml-router-dlq"
  visibility_timeout_seconds = 180
}

resource "aws_sqs_queue" "main" {
  name = "ml-router-queue"
  visibility_timeout_seconds = 180

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.main.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowS3SendMessage",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.main.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3:::ml-file-router-source"
          }
        }
      }
    ]
  })
}

output "queue_arn" {
  value = aws_sqs_queue.main.arn
}