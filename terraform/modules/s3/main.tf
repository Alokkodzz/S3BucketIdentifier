resource "aws_s3_bucket" "source" {
  bucket = "ml-file-router-source"
}

locals {
  buckets = [
    "alokk-na3-exports", "alokk-na4-exports", "alokk-na5-exports", "alokk-na6-exports",
    "alokk-na7-exports", "alokk-na8-exports", "alokk-na9-exports",
    "alokk-na12-exports", "alokk-ap1-exports", "alokk-sb1-exports", "alokk-sb2-exports",
    "alokk-eu1-exports", "alokk-eu2-exports", "alokk-eu3-exports"
  ]
}

resource "aws_s3_bucket" "targets" {
  for_each = toset(local.buckets)
  bucket   = each.value
}

output "source_bucket" {
  value = aws_s3_bucket.source.id
}
