variable "region" {
  default = "us-east-1"
  description = "AWS region"
}

variable "vpc_name" {
  type = "string"
  default = "eks-vpc"
}

variable "vpc_cidr" {
  default  = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_type" {
  type = "string"
  default = "private"
}

variable "azs" {
  type = "list"
  default = ["us-west-1a", "us-west-1b", "us-west-1c"]
}

variable "cluster_name" {
  default = "test-eks-cluster"
  description = "AWS eks cluster name"
}

variable "env" {
  type = "string"
  default = "test"
}

variable "team" {
  type = "string"
  default = "devops"
}

variable "service" {
  type = "string"
  default = "devops"
}
