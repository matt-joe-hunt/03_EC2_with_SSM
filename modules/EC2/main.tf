data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "simple-ec2" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.vpc-security-group-ids]
  subnet_id                   = var.public-subnet
  iam_instance_profile        = var.iam-instance-profile
  user_data                   = <<EOF
    #!/bin/bash
    yum install -y ssm-agent
    systemctl enable --now amazon-ssm-agent
  EOF
  tags = {
    Name = var.instance-name
  }

  lifecycle {
    create_before_destroy = true
  }
}