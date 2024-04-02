output "nat_id" {
    description = "The IP of the nat-gateway"
    value       = aws_nat_gateway.project01-nat.id
}