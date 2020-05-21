variable "region" {
  default = "ap-south-1"
  description = "AWS region"
}

variable "vpc_name" {
  default = "eks-vpc"
}

variable "eks_vpc_cidr" {
  default  = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "cluster_name" {
  default = "test-eks-cluster"
  description = "AWS eks cluster name"
}

variable "env" {
  default = "test"
}

variable "team" {
  default = "devops"
}

variable "service" {
  default = "devops"
}
