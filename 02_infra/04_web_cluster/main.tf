// 시작템플릿 (네트워크X) [첫째]
resource "aws_launch_template" "example" {
    name = "aws03-example-template"
    image_id = "ami-0da33c797f26f6822"
    instance_type = "t2.micro"
    key_name = "aws03-key"
    vpc_security_group_ids = [aws_security_group.web.id, aws_security_group.ssh.id]
// 생성 후에 lifecycle 작성 [둘째]

    user_data = "${base64encode(data.template_file.web_output.rendered)}"
//템플릿에 유저데이터 넣음

    lifecycle {
      create_before_destroy = true
    }
}

// 오토스케일링 그룹 [셋째] 이름 템플릿 크기 네트워크(가용영역 or 서브넷[가용영역포함])
resource "aws_autoscaling_group" "example" {
    availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
    # vpc_zone_identifier = ["var.subnet_2a,var.subnet_2c"]
    name = "aws03-asg-example"
    desired_capacity = 1
    min_size = 1
    max_size = 2

    launch_template {
        id = aws_launch_template.example.id
        version = "$Latest"
    }
    
    tag {
        key = "Name"
        value = "aws03-asg-example"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "web" {
    name = "aws03-example-web"
    ingress {
        from_port = var.web_port
        to_port = var.web_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "ssh" {
    name = "aws03-example-ssh"
    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
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