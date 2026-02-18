terraform {
  backend "s3" {
    bucket = "s3-fiap-soat-___AWS_ACCOUNT_ID___"
    key    = "fiap/terraform.tfstate"
    region = "us-east-1"
  }
}