# Terraform Training

Hands-on Terraform practice repository focused on core AWS infrastructure patterns.

## Terraform Lifecycle Basics

Terraform works in a predictable lifecycle where you define infrastructure as code and Terraform keeps real resources aligned with that desired state.

1. Write configuration
	- Define resources, variables, providers, and outputs in `.tf` files.
2. Initialize with `terraform init`
	- Downloads providers and modules.
	- Configures backend (for example S3 remote state) when defined.
3. Validate and format (recommended)
	- `terraform fmt` to normalize style.
	- `terraform validate` to catch syntax or schema issues early.
4. Plan with `terraform plan`
	- Compares configuration vs current state and previews changes.
5. Apply with `terraform apply`
	- Executes the plan and creates/updates/destroys resources.
6. Track state
	- Terraform records infrastructure state in `terraform.tfstate` (local or remote backend).
7. Update iteratively
	- Modify code, run `plan`, then `apply` again.
8. Destroy when needed
	- `terraform destroy` removes managed resources.

## AWS Services Tested in This Repository

- Amazon EC2
- Amazon VPC
- Subnets (public/private)
- Route Tables and Route Table Associations
- Internet Gateway
- NAT Gateway
- Elastic IP
- Security Groups
- Amazon S3
- S3 Bucket Lifecycle Configuration
- AWS CloudTrail
- Amazon CloudWatch (Log Group, Metric Filter, Alarm)
- Amazon SNS (Topic and Email Subscription)

## Practice Folder Summary

### 01_FirstInstance

- Uses Terraform module pattern (`module/ec2`) to provision one EC2 instance.
- Exposes useful outputs: instance ID, public IP, and availability zone.
- Includes S3 backend configuration for remote state storage.

### 02_HandOn_EC2

- Provisions a complete basic stack for a public EC2 server.
- Creates VPC, subnet, internet gateway, route table, and security group.
- Launches EC2 with `user_data` to install and start Apache (`httpd`).
- Also creates an S3 bucket and stores Terraform state in S3 backend.

### 03_S3

- Creates a dedicated S3 bucket with tags.
- Adds lifecycle management rule:
  - transition objects to `STANDARD_IA` after 30 days,
  - expire objects after 365 days.
- Uses variable-driven region and bucket naming.

### 04_Network

- Builds a VPC network layout with one public and one private subnet.
- Configures internet access path for public subnet via Internet Gateway.
- Configures outbound internet for private subnet via NAT Gateway + Elastic IP.
- Creates route tables and security groups for both subnet roles.

### 05_CloudWatchTrails

- Creates CloudTrail and stores audit logs in an S3 bucket.
- Creates CloudWatch log group and metric filter for unauthorized/access denied events.
- Creates CloudWatch alarm and sends notifications to an SNS topic with email subscription.
- Demonstrates basic monitoring and security alerting flow.

