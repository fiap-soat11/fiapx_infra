variable "regionDefault" {
  type = string
}

variable "projectName" {
  type = string
}

variable "labRole" {
  type = string
}

variable "accessConfig" {
  type = string
}

variable "principalArn" {
  type = string
}

variable "policyArn" {
  type = string
}

variable "nodeGroup" {
  type = string
}

variable "instanceType" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "aws_subnets" {
  type = list(string)
}