variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name to use for SSH (create in AWS console or with aws cli)"
}
