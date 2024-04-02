# # 라우터
# # public route table
# resource "aws_default_route_table" "project01-public-rt-table" {
#     default_route_table_id = aws_vpc.project01-vpc.default_route_table_id 
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.project01-igw.id
#     }
#     tags = {
#         Name = "project01-public-rt-table"
#     }
# }

# resource "aws_route_table_association" "project01-public-rt-2a" {
#     subnet_id = aws_subnet.project01-public-subnet-2a.id
#     route_table_id = aws_default_route_table.project01-public-rt-table.id
# }

# resource "aws_route_table_association" "project01-public-rt-2c" {
#     subnet_id = aws_subnet.project01-public-subnet-2c.id
#     route_table_id = aws_default_route_table.project01-public-rt-table.id
# }




# private route table
resource "aws_route_table" "project01-private-rt-table" {
    vpc_id = data.terraform_remote_state.vpc.project01-vpc.id
    tags = {
        Name = "project01-private-rt-table"
    }
}

# private router
resource "aws_route" "project01-private-rt" {
    route_table_id = aws_route_table.project01-private-rt-table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = data.terraform_remote_state.nat.project01-nat.id   
}

resource "aws_route_table_association" "project01-private-rt-2a" {
    subnet_id = data.terraform_remote_state.subent.project01-private-subnet-2a.id
    route_table_id = aws_route_table.project01-private-rt-table.id
}

resource "aws_route_table_association" "project01-private-rt-2c" {
    subnet_id = data.terraform_remote_state.subent.project01-private-subnet-2c.id
    route_table_id = aws_route_table.project01-private-rt-table.id
}