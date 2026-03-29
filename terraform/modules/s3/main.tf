resource "aws_s3_bucket" "source" {
  bucket = "ml-file-router-source"
}

locals {
  buckets = [
    "na3-exports", "na4-exports", "na5-exports", "na6-exports",
    "na7-exports", "na8-exports", "na9-exports", "na10-exports",
    "na12-exports", "ap1-exports", "sb1-exports", "sb2-exports",
    "eu1-exports", "eu2-exports", "eu3-exports"
  ]
}

resource "aws_s3_bucket" "targets" {
  for_each = toset(local.buckets)
  bucket   = each.value
}

output "source_bucket" {
  value = aws_s3_bucket.source.id
}