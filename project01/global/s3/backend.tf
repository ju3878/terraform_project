terraform {
  backend "s3" {
    bucket = "project01-terraform-state"
    region = "ap-northeast-2"
    key = "global/s3/terraform.tfstate"
    dynamodb_table = "project01-terraform-locks"
    encrypt  = true
  }
}