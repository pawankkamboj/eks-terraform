#
resource "aws_vpc" "vpc" {
  cidr_block             = "${var.vpc_cidr}"
  enable_dns_hostnames   =  true
  enable_dns_support     =  true

  tags = map(
    "Name", "${var.env}-${var.service}-vpc",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_subnet" "subnet" {
  count = "${length(var.subnet_cidrs)}"

  availability_zone       = "${element(var.azs, count.index)}"
  cidr_block              = "${element(var.subnet_cidrs, count.index)}"
  vpc_id                  = aws_vpc.vpc.id

  tags = map(
    "Name", "${var.env}-${var.service}-${var.subnet_type}-subnets",
    "SubnetType", "${var.subnet_type}",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.service}-ig"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "${var.env}-${var.service}-rt"
  }
}

resource "aws_route_table_association" "route_table_a" {
  count = "${length(var.subnet_cidrs)}"

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table.id
}


resource "aws_eip" "eips" {
  vpc   = true
  count = "${length(var.azs)}"
  tags = {
    Name = "${var.env}-${var.service}-eips-${element(var.azs, count.index)}"
  }
}

resource "aws_nat_gateway" "gw" {
  count = "${length(var.subnet_cidrs)}"
  allocation_id = aws_eip.eips.*.id[count.index]
  subnet_id      = aws_subnet.subnet.*.id[count.index]
  tags = {
    Name = "${var.env}-${var.service}-gw-${element(var.azs, count.index)}"
  }
}

