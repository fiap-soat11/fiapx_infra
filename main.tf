
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "fiapx-video-s3"
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning = {
    enabled = true
  }
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  name = "fiapx-video.fifo"
  fifo_queue = true
}

module "database" {
  source             = "./modules/database"
  projectName        = var.projectName
  regionDefault      = var.regionDefault
  vpc_id             = data.aws_vpc.vpc.id
  private_subnet_ids = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "${var.regionDefault}e"]
}


module "eks" {
  source        = "./modules/eks"
  projectName   = var.projectName
  regionDefault = var.regionDefault
  labRole       = "arn:aws:iam::${var.id}:role/LabRole"
  accessConfig  = var.accessConfig
  policyArn     = var.policyArn
  principalArn  = "arn:aws:iam::${var.id}:role/voclabs"
  nodeGroup     = var.nodeGroup
  instanceType  = var.instanceType
  vpc_id        = data.aws_vpc.vpc.id
  aws_subnets   = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "${var.regionDefault}e"]
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  regionDefault     = var.regionDefault
  dns_eks_usuario   = var.dns_eks_usuario
  dns_eks_video     = var.dns_eks_video
}

