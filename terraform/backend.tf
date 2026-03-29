terraform {
  backend "s3" {
    bucket = "alokk-mlopss"
    key    = "State/terraform.tfstate"
    region = "ap-southeast-2"
  }
}
