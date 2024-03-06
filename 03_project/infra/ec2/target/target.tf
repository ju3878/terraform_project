resource "aws_instance" "target" {
    ami           = "ami-09eb4311cbaecf89d"
    instance_type = "t2.micro"
    key_name      = "aws03-key"
    // 퍼플릭 IP 활성화
    associate_public_ip_address = true
    // 보안그룹 연결 // remote
    subnet_id = data.terraform_remote_state.vpc.outputs.public-subnet-2a-id
    security_groups = [data.terraform_remote_state.security_group.outputs.ssh_id] 
                      #  data.terraform_remote_state.security_group.outputs.http_id, 
                      #  data.terraform_remote_state.security_group.outputs.https_id]

    # user_data = "${base64encode(data.template_file.user_data.rendered)}"
    user_data = templatefile("template/userdata.sh", {})

    tags = {
      Name = "aws03-target"
    }
}