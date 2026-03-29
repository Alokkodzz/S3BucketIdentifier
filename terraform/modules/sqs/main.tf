resource "aws_sqs_queue" "dlq" {
  name = "ml-router-dlq"
}

resource "aws_sqs_queue" "main" {
  name = "ml-router-queue"

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
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.main.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = "*"
          }
        }
      }
    ]
  })
}

output "queue_arn" {
  value = aws_sqs_queue.main.arn
}