terraform {
  backend "s3" {
    bucket = "s3-fiap-soat-__AWS_ACCOUNT_ID__"
    key    = "fiap/terraform.tfstate"
    region = "us-east-1"
  }
}