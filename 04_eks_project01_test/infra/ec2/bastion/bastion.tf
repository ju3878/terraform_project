resource "aws_instance" "bastion" {
    ami           = "ami-02c956980e9e063e5"
    instance_type = "t2.micro"
    key_name      = "project01-key"
    // 퍼플릭 IP 활성화
    associate_public_ip_address = true
    security_groups = [data.terraform_remote_state.security_group.outputs.ssh_id] 
    //                   ,data.terraform_remote_state.security_group.outputs.http_id, 
    //                   data.terraform_remote_state.security_group.outputs.https_id]
    // 보안그룹 연결 // remote
    subnet_id = data.terraform_remote_state.vpc.outputs.public-subnet-2a-id

    tags = {
      Name = "project01-test01-bastion"
    }
}