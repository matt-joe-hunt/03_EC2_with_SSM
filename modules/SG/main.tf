resource "aws_security_group" "sg" {
  name        = var.sg-name
  description = "Allow access to port 443 from host machine and access to internet"
  vpc_id      = var.vpc-id

  ingress {
    description = "Allow 443 from host machine"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}