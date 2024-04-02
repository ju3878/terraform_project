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

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "template_file" "web_output" {
  template = file("${path.module}/web.sh")
  vars = {
    web_port = "${var.web_port}"
    // web.sh ; -p {web.port} (쉘파일)  == 
    //                   variable.tf ; variable "web-port" {default = 8080} (테라폼파일)
  }
}