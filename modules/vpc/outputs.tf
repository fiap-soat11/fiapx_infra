output "vpc_id" {
  value = aws_vpc.main.id
}

output "aws_subnet_eks1" {
  value = aws_subnet.eks1.id
}
output "aws_subnet_eks2" {
  value = aws_subnet.eks2.id
}
output "aws_subnet_eks3" {
  value = aws_subnet.eks3.id
}