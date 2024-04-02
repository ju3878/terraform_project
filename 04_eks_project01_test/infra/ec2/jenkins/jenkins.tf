resource "aws_instance" "jenkins" {
    ami                         = "ami-0d3d9b94632ba1e57"
    instance_type               = "t3.large"
    key_name                    = "project01-key"
    private_ip                  = "10.101.64.100"
    security_groups = [data.terraform_remote_state.security_group.outputs.ssh_id,
                       data.terraform_remote_state.security_group.outputs.http_id, 
                       data.terraform_remote_state.security_group.outputs.https_id]
    // 보안그룹 연결 // remote
    subnet_id = data.terraform_remote_state.vpc.outputs.private-subnet-2a-id

    user_data = templatefile("template/userdata.sh", {})

    tags = {
      Name = "project01-test01-jenkins"
    }
}
