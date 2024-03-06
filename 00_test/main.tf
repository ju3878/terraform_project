provider "aws" {
  region = "ap-northest-2"
}


//생성한VPC에서 있는 내용 뽑아올때
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
  name = "vpc-id"
  values = [data.aws_vpc.default.id]
  }
}






# terraform {
#   # Terraform 버전 지정
#   required_version = ">= 1.0.0, < 2.0.0"

#   # 공급자 지정
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }
# provider "aws" {
#   region = "ap-northeast-2"
# }

# resource "aws_instance" "example" {
#   ami           = "ami-09eb4311cbaecf89d"
#   instance_type = "t2.micro"
#   key_name      = "aws03-key"

#   tags = {
#     Name = "aws03-example"
#     org  = "busanit"
#   }
# }
