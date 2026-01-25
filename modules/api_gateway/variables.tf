variable "id" {
  type = string
  
}


variable "dns_eks_pedido" {
  description = "DNS do LoadBalancer do Service Pedido no EKS"
  type        = string
}
variable "dns_eks_pagamento" {
  description = "DNS do LoadBalancer do Service Pagamento no EKS"
  type        = string
}
variable "dns_eks_preparo" {
  description = "DNS do LoadBalancer do Service Preparo no EKS"
  type        = string
}
variable "regionDefault" {
  type = string
}
