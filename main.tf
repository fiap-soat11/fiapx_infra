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

//module "api_gateway" {
//  source        = "./modules/api_gateway"
//  id            = var.id
//  uri_lambda    = data.aws_lambda_function.fiap-lambda.arn
//  function_name = data.aws_lambda_function.fiap-lambda.function_name
//  regionDefault = var.regionDefault
//  dns_eks       = var.dns_eks
//}

module "api_gateway" {
  source            = "./modules/api_gateway"
  id                = var.id
  regionDefault     = var.regionDefault
  dns_eks_pedido    = var.dns_eks_pedido
  dns_eks_pagamento = var.dns_eks_pagamento
  dns_eks_preparo   = var.dns_eks_preparo
}