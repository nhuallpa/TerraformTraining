provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "TerraVPC"
    }
}

resource "aws_internet_gateway" "example_igw" {
    vpc_id = aws_vpc.example_vpc.id
    tags = {
        Name = "TerraIGW"
    }
}

resource "aws_route_table" "example_rt" {
    vpc_id = aws_vpc.example_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.example_igw.id
    }

    tags = {
        Name = "TerraPublicRT"
    }
}

resource "aws_route_table_association" "example_rta" {
    subnet_id      = aws_subnet.example_subnet.id
    route_table_id = aws_route_table.example_rt.id
}

resource "aws_subnet" "example_subnet" {
    vpc_id            = aws_vpc.example_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "TerraSubnet"
    }
}

resource "aws_instance" "example" {
    ami                         = "ami-098e39bafa7e7303d"
    instance_type               = "t3.micro"
    subnet_id                   = aws_subnet.example_subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.instance_sg.id]
    tags = {
        Name = "ExampleInstance"
    }

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello, World!" > /var/www/html/index.html
                EOF

    root_block_device {
        volume_size = 8
        volume_type = "gp2"
    }
}

resource "aws_security_group" "instance_sg" {
    name        = "instance_sg"
    description = "Security group for EC2 instance"
    vpc_id      = aws_vpc.example_vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "example_backet" {
    bucket = "example-bucket-terraform-2024"
    acl    = "private"
}

terraform {
    backend "s3" {
        bucket = "example-bucket-terraform-2024"
        key    = "example-bucket-terraform-2024/statefiles/state.tfstate"
        region = "us-east-1"
        encrypt = true
    }
}