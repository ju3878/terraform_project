data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "aws03-terraform-state"
        key = "infra/vpc/terraform.tfstate"
        // 상태코드 위치를 가져오기 
        region = "ap-northeast-2"
    }
}

data "terraform_remote_state" "security_group" {
    backend = "s3"
    config = {
        bucket = "aws03-terraform-state"
        key = "infra/ec2/security_group/terraform.tfstate"
        // 상태코드 위치를 가져오기 
        region = "ap-northeast-2"
  }
}