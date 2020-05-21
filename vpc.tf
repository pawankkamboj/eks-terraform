data "aws_security_group" "default_sg" {
  name   = "default"
  vpc_id = module.eks_vpc.vpc_id
}

data "aws_subnet" "private_subnet_1" {
  availability_zone = var.azs[0]
  vpc_id            = module.eks_vpc.vpc_id
  cidr_block        = "${cidrsubnet(var.eks_vpc_cidr, 8, 0)}"
}
data "aws_subnet" "private_subnet_2" {
  availability_zone = var.azs[1]
  vpc_id            = module.eks_vpc.vpc_id
  cidr_block        = "${cidrsubnet(var.eks_vpc_cidr, 8, 1)}"
}
data "aws_subnet" "private_subnet_3" {
  availability_zone = var.azs[2]
  vpc_id            = module.eks_vpc.vpc_id
  cidr_block        = "${cidrsubnet(var.eks_vpc_cidr, 8, 2)}"
}

resource "aws_eip" "eks_vpc_nat_eips" {
  vpc   = true
  count = length(var.azs)
  tags = {
    Name = "${var.env}-${var.service}-${element(var.azs, count.index)}"
  }
}
module "eks_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

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
  reuse_nat_ips          = true
  #external_nat_ip_ids    = [
  #  "${aws_eip.eks_vpc_nat_eips.*.id}"
  #]

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


