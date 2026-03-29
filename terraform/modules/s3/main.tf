resource "aws_s3_bucket" "source" {
  bucket = "ml-file-router-source"
}

locals {
  buckets = [
    "na3_exports", "na4_exports", "na5_exports", "na6_exports",
    "na7_exports", "na8_exports", "na9_exports", "na10_exports",
    "na12_exports", "ap1_exports", "sb1_exports", "sb2_exports",
    "eu1_exports", "eu2_exports", "eu3_exports"
  ]
}

resource "aws_s3_bucket" "targets" {
  for_each = toset(local.buckets)
  bucket   = each.value
}

output "source_bucket" {
  value = aws_s3_bucket.source.id
}