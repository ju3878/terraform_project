terraform {
    backend "s3" {
        bucket         = "projcet01-terraform-state"
        region         = "ap-northeast-2"
        key            = "infra/vpc/router/private/terraform.tfstate"
        dynamodb_table = "projcet01-terraform-locks"
        encrypt        = true
    }
}