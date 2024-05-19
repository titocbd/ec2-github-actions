# Creating an AWS instance for the Bastion Host, It should be launched in the public Subnet!
resource "aws_instance" "Bastion-Host" {
   depends_on = [
    aws_instance.webserver,
     aws_instance.MySQL
  ]
  
  ami = "ami-0cd59ecaf368e5ccf"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id

  # Keyname and security group are obtained from the reference of their instances created above!
  key_name = "MyKeyFinal"
   
  # Security group ID's
  vpc_security_group_ids = [aws_security_group.BH-SG.id]
  tags = {
   Name = "Bastion_Host_From_Terraform"
  }
}