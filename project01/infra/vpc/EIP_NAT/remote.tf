data "terraform_remote_state" "subnet" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/subnets/terraform.tfstate"
        region = "ap-northeast-2"
    }
}























# data "terraform_remote_state" "igw" {
#     backend = "s3"
#     config = {
#         bucket = "project01-terraform-state"
#         key = "infra/igw/terraform.tfstate"
#         region = "ap-northeast-2"
#     }
# }


# data "terraform_remote_state" "vpc" {
#   backend = "s3"
#   config = {
#     bucket = "project01-terraform-state"
#     key = "infra/vpc/terraform.tfstate"
#     region = "ap-northeast-2"
#   }
# }