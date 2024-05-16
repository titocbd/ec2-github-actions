# Create VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "20.10.0.0/16"
  #enable_dns_support = true
  #enable_dns_hostnames = true

  tags = {
    Name = "iac-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "tf_public_subnets" { 
 vpc_id     = aws_vpc.tf_vpc.id
 cidr_block = "20.10.10.0/24"
  # Data Center of this subnet.
  availability_zone = "us-east-1a"
  
  # Enabling automatic public IP assignment on instance launch!
  map_public_ip_on_launch = true

 tags = {
   Name = "TF Public Subnet1"
 }
}
 
# Create private subnet
resource "aws_subnet" "tf_private_subnets" { 
 vpc_id     = aws_vpc.tf_vpc.id
 cidr_block = "20.10.10.0/24"
  # Data Center of this subnet.
  availability_zone = "us-east-1a"
 
 tags = {
   Name = "TF Private Subnet1"
 }
}
 
 
