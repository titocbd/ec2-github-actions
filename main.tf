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
  depends_on = [
    aws_vpc.tf_vpc
  ]
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
  depends_on = [
    aws_vpc.tf_vpc,
    aws_subnet.tf_public_subnets
  ]
  
 vpc_id     = aws_vpc.tf_vpc.id
 cidr_block = "20.10.11.0/24"
  # Data Center of this subnet.
  availability_zone = "us-east-1a"
 
 tags = {
   Name = "TF Private Subnet1"
 }
}

# Creating a Security Group for Application Server
resource "aws_security_group" "Webserver-SG" {

  depends_on = [
    aws_vpc.tf_vpc,
    aws_subnet.tf_public_subnets,
    aws_subnet.tf_private_subnets
  ]

  description = "HTTP, PING, SSH"

  # Name of the security Group!
  name = "webserver-sg"
  
  tags = {
    Name = "Webserver SG"
  }

  # VPC ID in which Security group has to be created!
  vpc_id = aws_vpc.tf_vpc.id

  # Created an inbound rule for webserver access!
  ingress {
    description = "HTTP for webserver"
    from_port   = 80
    to_port     = 80

    # Here adding tcp instead of http, because http in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Created an inbound rule for ping
  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Created an inbound rule for SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    # Here adding tcp instead of ssh, because ssh in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outward Network Traffic for the WordPress
  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "iac-lb" {
  ami           = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.tf_public_subnets.id
  security_groups = [aws_security_group.Webserver-SG.id]

  tags = {
    Name = "iac_load_balancer"
  }
} 
 
