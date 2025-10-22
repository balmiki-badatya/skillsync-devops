output "vpc_id" {
  description = "AWS vpc id"
  value       = aws_vpc.skillsync_vpc.id
  depends_on  = [aws_vpc.skillsync_vpc]

}