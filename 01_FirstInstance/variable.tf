variable "instance_type" {
  description = "The type of instance to create"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  default     = "ami-098e39bafa7e7303d"
}