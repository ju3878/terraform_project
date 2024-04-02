terraform {
    backend "s3" {
        bucket         = "aws03-terraform-state"
        region         = "ap-northeast-2"
        key            = "infra/vpc/terraform.tfstate"
        dynamodb_table = "aws03-terraform-looks"
        encrypt        = true
    }
}