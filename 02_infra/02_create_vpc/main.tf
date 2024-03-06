resource "aws_vpc" "aws03-vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws03-vpc"
  }
}


// ------------- 서브넷 생성 -------------
// ap-northeast-2a
resource "aws_subnet" "aws03-public-subnet-2a" {
  vpc_id     = aws_vpc.aws03-vpc.id
  cidr_block = var.public_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "aws03-public-subnet-2a"
  }
}

resource "aws_subnet" "aws03-private-subnet-2a" {
  vpc_id     = aws_vpc.aws03-vpc.id
  cidr_block = var.private_subnet[0]
  availability_zone = var.azs[0]

  tags = {
    Name = "aws03-private-subnet-2a"
  }
}

// ap-northeast-2c
resource "aws_subnet" "aws03-public-subnet-2c" {
  vpc_id     = aws_vpc.aws03-vpc.id
  cidr_block = var.public_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "aws03-public-subnet-2c"
  }
}

resource "aws_subnet" "aws03-private-subnet-2c" {
  vpc_id     = aws_vpc.aws03-vpc.id
  cidr_block = var.private_subnet[1]
  availability_zone = var.azs[1]

  tags = {
    Name = "aws03-private-subnet-2c"
  }
}


// 인터넷 게이트웨이
resource "aws_internet_gateway" "aws03-igw" {
  vpc_id = aws_vpc.aws03-vpc.id

  tags = {
    Name = "aws03-igw"
  }
}

// EIP
resource "aws_eip" "aws03-eip" {
  domain     = "vpc"
  depends_on = [ "aws_internet_gateway.aws03-igw" ]  
  lifecycle {
    create_before_destroy = true
  }
}

// NAT 게이트웨이 private > public 변환해서 인터넷으로 나감
resource "aws_nat_gateway" "aws03-nat" {
  allocation_id = aws_eip.aws03-eip.id
  subnet_id     = aws_subnet.aws03-public-subnet-2a.id
  depends_on    = [ "aws_internet_gateway.aws03-igw" ]

  tags = {
    Name = "aws03-nat"
  }
}

// 라우터 // public 1개 private 2개 
// public router table
resource "aws_default_route_table" "aws03-public-rt-table" {
  default_route_table_id = aws_vpc.aws03-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws03-igw.id
  }
  tags = {
    Name = "aws03-public-rt-table"
  }
}

// public 서브넷 연결 인터넷게이트웨이
resource "aws_route_table_association" "aws03-public-rt-2a" {
  subnet_id = aws_subnet.aws03-public-subnet-2a.id
  route_table_id = aws_default_route_table.aws03-public-rt-table.id
}

resource "aws_route_table_association" "aws03-public-rt-2c" {
  subnet_id = aws_subnet.aws03-public-subnet-2c.id
  route_table_id = aws_default_route_table.aws03-public-rt-table.id
}

// private router table
resource "aws_route_table" "aws03-private-rt-table" {
  vpc_id = aws_vpc.aws03-vpc.id  
  tags = {
    Name = "aws03-private-rt-table"
  }  
}

// private router
resource "aws_route" "aws03-private-rt" {
  route_table_id = aws_route_table.aws03-private-rt-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.aws03-nat.id
}

resource "aws_route_table_association" "aws03-private-rt-2a" {
  subnet_id = aws_subnet.aws03-private-subnet-2a.id
  route_table_id = aws_route_table.aws03-private-rt-table.id
}

resource "aws_route_table_association" "aws03-private-rt-2c" {
  subnet_id = aws_subnet.aws03-private-subnet-2c.id
  route_table_id = aws_route_table.aws03-private-rt-table.id
}