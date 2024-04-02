// 시작템플릿 (네트워크X) [첫째]
resource "aws_launch_template" "example" {
  name                   = "aws03-example-template"
  image_id               = "ami-0da33c797f26f6822"
  instance_type          = "t2.micro"
  key_name               = "aws03-key"
  vpc_security_group_ids = [data.terraform_remote_state.security_group.outputs.http_id]
  // 생성 후에 lifecycle 작성 [둘째]

  user_data = base64encode(data.template_file.web_output.rendered)
  //템플릿에 유저데이터 넣음

  lifecycle {
    create_before_destroy = true
  }
}

// 오토스케일링 그룹 [셋째] 이름 템플릿 크기 네트워크(가용영역 or 서브넷[가용영역포함])
resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier = [data.terraform_remote_state.vpc.outputs.private-subnet-2a-id, 
                         data.terraform_remote_state.vpc.outputs.private-subnet-2c-id, ]
  
  name             = "aws03-asg"
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