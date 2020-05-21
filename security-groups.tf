
resource "aws_security_group" "worker_group_mgmt" {
  name_prefix = "${var.env}-${var.service}-node"
  vpc_id      = module.eks_vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}
