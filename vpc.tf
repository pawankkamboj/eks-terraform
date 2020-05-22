
module "eks_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = "${var.env}-${var.service}-vpc"
  cidr = var.eks_vpc_cidr

  azs  = var.azs
  private_subnets = [
    "${cidrsubnet(var.eks_vpc_cidr, 8, 0)}",
    "${cidrsubnet(var.eks_vpc_cidr, 8, 1)}",
    "${cidrsubnet(var.eks_vpc_cidr, 8, 2)}"
  ]
  public_subnets  = [
    "${cidrsubnet(var.eks_vpc_cidr, 8, 20)}",
    "${cidrsubnet(var.eks_vpc_cidr, 8, 21)}",
    "${cidrsubnet(var.eks_vpc_cidr, 8, 22)}"
  ]

  # VPC DNS & NAT
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  one_nat_gateway_per_az = true
  single_nat_gateway     = false

  tags = {
    Terraform = "true"
    Service   = var.service
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
     SubnetType = "public"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
     SubnetType = "private"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


