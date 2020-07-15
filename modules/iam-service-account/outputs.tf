 
output "this_iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.this.arn
}

output "this_iam_role_name" {
  description = "Name of IAM role"
  value       = aws_iam_role.this.name
}

output "this_iam_role_path" {
  description = "Path of IAM role"
  value       = aws_iam_role.this.name
}