resource "aws_security_group" "sg" {
  name        = var.sg-name
  description = "Allow access to port 443 from host machine and access to internet"
  vpc_id      = var.vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  self = true
}