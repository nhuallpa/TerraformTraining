terraform {
 required_version = ">= 1.5.0"
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
}

provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "my-terraform-state--use1-az4--x-s3"
        key    = "my-terraform-state--use1-az4--x-s3/backup/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
    }
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
    value = module.ec2_instance.instance_id
}   

# Output availability zone
output "availability_zone" {
    value = module.ec2_instance.availability_zone
}