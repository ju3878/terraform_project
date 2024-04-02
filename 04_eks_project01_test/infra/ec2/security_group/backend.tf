terraform {
    backend "s3" {
        bucket         = "project01-test-terraform-state"
        region         = "ap-northeast-2"
        key            = "test01/infra/ec2/security_group/terraform.tfstate"
        dynamodb_table = "project01-test01-terraform-locks"
        encrypt        = true
    }
}