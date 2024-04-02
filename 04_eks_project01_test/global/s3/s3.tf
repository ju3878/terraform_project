# resource "aws_s3_bucket" "terraform-state" {
#     bucket = "project01-test-terraform-state"  

#     # # 실수로 버킷을 삭제하는 것을 방지한다.
#     # lifecycle {
#     #     prevent_destroy = true      
#     # }
#     lifecycle {
#         prevent_destroy = false
#     }
#     force_destroy = true

#     tags = {
#         Name = "aproject01-test-terraform-state"
#     }
# }

# S3 동시접속 방지 잠금장치
resource "aws_dynamodb_table" "terraform-locks" {
    name = "project01-test01-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
