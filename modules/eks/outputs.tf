#output "dns_eks" {
#  value = kubernetes_service.fiap_svc.status[0].load_balancer[0].ingress[0].hostname  
#}