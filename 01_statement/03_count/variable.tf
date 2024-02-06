variable "user_names" {
    description = "Create IAM users with these names"
    type        = list(string)
    # default     = ["aws03-neo", "aws03-morpheus"]
    default     = ["aws03-neo", "aws03-trinity", "aws03-morpheus"]
}