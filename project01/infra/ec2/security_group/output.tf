output "ssh_id" {
  description = "The port will use for SSH requests"
  value = aws_security_group.SSH.id  
}
output "http_id" {
  description = "The port will use for HTTP requests"
  value = aws_security_group.HTTP.id  
}
output "https_id" {
  description = "The port will use for HTTPS requests"
  value = aws_security_group.HTTPS.id  
}
output "jenkins_id" {
  description = "The port will use for jenkins requests"
  value = aws_security_group.jenkins.id  
}