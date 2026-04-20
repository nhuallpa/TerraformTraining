resource "aws_instance" "first_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
        Name = "FirstInstanceInTerraform"
    }
}   