variable "vpc_id" {
  default = "vpc-12345678"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-12345678"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_ids" {
  default = ["subnet-12345678"]
}

variable "key_pair" {
  default = "default"
}
