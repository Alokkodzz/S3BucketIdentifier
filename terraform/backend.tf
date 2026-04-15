terraform {
  backend "s3" {
    bucket = "alokk-mlopss-tf-backend"
    key    = "State/terraform.tfstate"
    region = "ap-south-1"
  }
}
