provider "aws" {
  region = var.region-master
}

module "IAM" {
  source = "./modules/IAM"
}

module "EC2" {
  source = "./modules/EC2"

  instance-name          = "${var.project[terraform.workspace]}-Instance-${terraform.workspace}"
  instance-type          = var.instance-type[terraform.workspace]
  public-subnet          = module.VPC.public-subnet-id
  vpc-security-group-ids = module.SG.aws-sg
  iam-instance-profile   = module.IAM.iam-instance-profile
}

module "SG" {
  source = "./modules/SG"

  sg-name = "${var.project[terraform.workspace]}-SG-${terraform.workspace}"
  vpc-id  = module.VPC.vpc-id
}

module "VPC" {
  source = "./modules/VPC"

  vpc-name = "${var.project[terraform.workspace]}-VPC-${terraform.workspace}"
}