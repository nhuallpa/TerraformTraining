terraform {
 required_version = ">= 1.0.0"
}

provider "aws" {
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./module/ec2"
    instance_type = var.instance_type
    ami_id = var.ami_id
}

# Output the public IP
output "public_ip" {
    value = module.ec2_instance.public_ip
}

# Output the instance ID
output "instance_id" {
    description = "The ID of the instance"
    value = module.ec2_instance.instance_id
}   

# Output availability zone
output "availability_zone" {
    description = "The availability zone of the instance"
    value = module.ec2_instance.availability_zone
}