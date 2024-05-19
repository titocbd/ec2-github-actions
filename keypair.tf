# Creating a New Key
resource "aws_key_pair" "Key-Pair" {

  # Name of the Key
  key_name   = "MyKeyFinal"

  # Adding the SSH authorized key !
  public_key = file("~/.ssh/aws_ssh_key.pub")
  
 }
