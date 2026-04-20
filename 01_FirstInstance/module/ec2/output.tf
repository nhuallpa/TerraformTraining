# Output the public IP
output "public_ip" {
    description = "The public IP address of the instance"
    value = aws_instance.first_instance.public_ip
}

# Output the instance ID
output "instance_id" {
    description = "The ID of the instance"
    value = aws_instance.first_instance.id
}   

# Output availability zone
output "availability_zone" {
    description = "The availability zone of the instance"
    value = aws_instance.first_instance.availability_zone
}