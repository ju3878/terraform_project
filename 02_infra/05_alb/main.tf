// 시작템플릿 (네트워크X) [첫째]
resource "aws_launch_template" "example" {
  name                   = "aws03-example-template"
  image_id               = "ami-0da33c797f26f6822"
  instance_type          = "t2.micro"
  key_name               = "aws03-key"
  vpc_security_group_ids = [aws_security_group.web.id, aws_security_group.ssh.id]
  // 생성 후에 lifecycle 작성 [둘째]
  user_data = base64encode(data.template_file.web_output.rendered)
  //템플릿에 유저데이터 넣음
  lifecycle {
    create_before_destroy = true
  }
}

// 오토스케일링 그룹 [셋째] 이름 템플릿 크기 네트워크(가용영역 or 서브넷[가용영역포함])
resource "aws_autoscaling_group" "example" {
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]
  # vpc_zone_identifier = ["var.subnet_2a,var.subnet_2c"]
  name             = "aws03-asg-example"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2

  //타겟구릅 대상그룹 연결
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "aws03-asg-example"
    propagate_at_launch = true
  }
}

// 로드밸런스 그룹
resource "aws_lb" "example" {
  name               = "aws03-alb-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

// 로드밸런스 리스너
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 8080
  protocol          = "HTTP" //네트워크 경우 tcp
  default_action {
    type = "fixed-response" 
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

// 로드밸런스 리스너 룰
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

// 대상그룹
resource "aws_lb_target_group" "asg" {
  name     = "aws03-target-group-example"
  port     = var.web_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  // 상태검사
  health_check {
    path               = "/"
    protocol           = "HTTP"
    matcher            = "200"
    interval           = 15
    timeout             = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

}


// 보안 그룹 - 로드벨런스
resource "aws_security_group" "alb" {
  name = "aws03-sg-example-alb"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// 보안 그룹 - 인스턴스
resource "aws_security_group" "web" {
  name = "aws03-sg-example-web"
  ingress {
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ssh" {
  name = "aws03-sg-example-ssh"
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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