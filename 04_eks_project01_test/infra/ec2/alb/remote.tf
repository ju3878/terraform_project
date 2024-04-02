data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "project01-test-terraform-state"
        key = "test01/infra/vpc/terraform.tfstate"
        region = "ap-northeast-2"
    }
}
data "terraform_remote_state" "security_group" {
    backend = "s3"
    config = {
        bucket = "project01-test-terraform-state"
        key = "test01/infra/ec2/security_group/terraform.tfstate"
        region = "ap-northeast-2"
    }
}
data "terraform_remote_state" "jenkins_instance" {
    backend = "s3"
    config = {
        bucket = "project01-test-terraform-state"
        key = "test01/infra/ec2/jenkins/terraform.tfstate"
        region = "ap-northeast-2"
    }
}