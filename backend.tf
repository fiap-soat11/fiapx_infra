terraform {
  backend "s3" {
    bucket = "s3-fiap-soat-902877452717"
    key    = "fiap/terraform.tfstate"
    region = "us-east-1"
  }
}