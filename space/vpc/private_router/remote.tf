data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/terraform.tfstate"
        // 상태코드 위치를 가져오기 
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "subnet" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/subnets/terraform.tfstate"
        // 상태코드 위치를 가져오기 
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "nat" {
    backend = "s3"
    config = {
        bucket = "project01-terraform-state"
        key = "infra/vpc/nat/terraform.tfstate"
        // 상태코드 위치를 가져오기 
        region = "ap-northeast-2"
    }
}

# data "terraform_remote_state" "nat" {
#     backend = "s3"
#     config = {
#         bucket = "project01-terraform-state"
#         key = "infra/vpc/nat/terraform.tfstate"
#         // 상태코드 위치를 가져오기 
#         region = "ap-northeast-2"
#     }
# }