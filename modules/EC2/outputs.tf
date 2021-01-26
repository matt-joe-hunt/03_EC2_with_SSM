output "public-ip" {
  value = aws_instance.simple-ec2.public_ip
}