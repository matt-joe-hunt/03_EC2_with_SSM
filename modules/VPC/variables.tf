variable "vpc-cidr-block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public-subnet-cidr-block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc-name" {
  type = string
}