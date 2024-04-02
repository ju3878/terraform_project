resource "aws_vpc" "project01-test01-vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "project01-test01-vpc"
  }
}


// ------------- 서브넷 생성 -------------
// ap-northeast-2a
resource "aws_subnet" "project01-test01-public-subnet-2a" {
  vpc_id     = aws_vpc.project01-test01-vpc.id
  cidr_block = var.public_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "project01-test01-public-subnet-2a"
    "kubernetes.io/role/elb" = 1
    "alpha.eksctl.io/cluster-oidc-enabled" = true
  }
}

resource "aws_subnet" "project01-test01-private-subnet-2a" {
  vpc_id     = aws_vpc.project01-test01-vpc.id
  cidr_block = var.private_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "project01-test01-private-subnet-2a"
    "kubernetes.io/role/internal-elb" = 1
    "alpha.eksctl.io/cluster-oidc-enabled" = true
  }
}

// ap-northeast-2c
resource "aws_subnet" "project01-test01-public-subnet-2c" {
  vpc_id     = aws_vpc.project01-test01-vpc.id
  cidr_block = var.public_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "project01-test01-public-subnet-2c"
    "kubernetes.io/role/internal-elb" = 1
    "alpha.eksctl.io/cluster-oidc-enabled" = true
  }
}

resource "aws_subnet" "project01-test01-private-subnet-2c" {
  vpc_id     = aws_vpc.project01-test01-vpc.id
  cidr_block = var.private_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "project01-test01-private-subnet-2c"
    "kubernetes.io/role/internal-elb" = 1
    "alpha.eksctl.io/cluster-oidc-enabled" = true
  }
}


// 인터넷 게이트웨이
resource "aws_internet_gateway" "project01-test01-igw" {
  vpc_id = aws_vpc.project01-test01-vpc.id

  tags = {
    Name = "project01-test01-igw"
  }
}

// EIP
resource "aws_eip" "project01-test01-eip" {
  domain     = "vpc"
  depends_on = [ aws_internet_gateway.project01-test01-igw ]  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "project01-test01-eip"
  }
}

// NAT 게이트웨이 private > public 변환해서 인터넷으로 나감
resource "aws_nat_gateway" "project01-test01-nat" {
  allocation_id = aws_eip.project01-test01-eip.id
  subnet_id     = aws_subnet.project01-test01-public-subnet-2a.id
  depends_on    = [ aws_internet_gateway.project01-test01-igw ]

  tags = {
    Name = "project01-test01-nat"
  }
}

// 라우터 // public 2개 private 1개 
// public router table
resource "aws_default_route_table" "project01-test01-public-rt-table" {
  default_route_table_id = aws_vpc.project01-test01-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project01-test01-igw.id
  }
  tags = {
    Name = "project01-test01-public-rt-table"
  }
}

// public 서브넷 연결 인터넷게이트웨이
resource "aws_route_table_association" "project01-test01-public-rt-2a" {
  subnet_id = aws_subnet.project01-test01-public-subnet-2a.id
  route_table_id = aws_default_route_table.project01-test01-public-rt-table.id
}

resource "aws_route_table_association" "project01-test01-public-rt-2c" {
  subnet_id = aws_subnet.project01-test01-public-subnet-2c.id
  route_table_id = aws_default_route_table.project01-test01-public-rt-table.id
}

// private router table
resource "aws_route_table" "project01-test01-private-rt-table" {
  vpc_id = aws_vpc.project01-test01-vpc.id  
  tags = {
    Name = "project01-test01-private-rt-table"
  }  
}

// private router
resource "aws_route" "project01-test01-private-rt" {
  route_table_id = aws_route_table.project01-test01-private-rt-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.project01-test01-nat.id
}

resource "aws_route_table_association" "project01-test01-private-rt-2a" {
  subnet_id = aws_subnet.project01-test01-private-subnet-2a.id
  route_table_id = aws_route_table.project01-test01-private-rt-table.id
}

resource "aws_route_table_association" "project01-test01-private-rt-2c" {
  subnet_id = aws_subnet.project01-test01-private-subnet-2c.id
  route_table_id = aws_route_table.project01-test01-private-rt-table.id
}