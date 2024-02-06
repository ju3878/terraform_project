provider "local" {}

output "number_example" { 
    value = var.number_example 
}
output "server_port" {
    value = var.server_port
    sensitive = true
}
# 전달할 값이 number인지 확인
variable "number_example" { 
    description = "An example of a number variable in Terraform" 
    type        = number 
    default     = 42
}
variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    // 나중에 사용할 때 옵션으로 적어 줄 수 있음
}