
variable "id" {
  default = "902877452717"
}
variable "regionDefault" {
  default = "us-east-1"
}
variable "projectName" {
  default = "EKS-FIAP"
}

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "nodeGroup" {
  default = "fiap"
}

variable "instanceType" {
  default = "t3.medium"
}

variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

//variable "image_uri" {
//  default = "902877452717.dkr.ecr.us-east-1.amazonaws.com/fiap-lambda@sha256:ff5673c87b712777e5c1b68d1ccc59e81ec2b074efae954305c3a28130d37313"
//}

variable "dns_eks_pedido" {
  type    = string
  default = "value"
}
variable "dns_eks_pagamento" {
  type    = string
  default = "value"
}
variable "dns_eks_preparo" {
  type    = string
  default = "value"
}