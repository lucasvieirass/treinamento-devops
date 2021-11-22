provider "aws" {
  region = "sa-east-1"
}
resource "aws_instance" "web2" {
  for_each = toset(["lucassouza","tatiane","lucia"])
  subnet_id     = "subnet-0fc6abd81bbb30292"
  ami= "ami-054a31f1b3bf90920"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "ec2-tf-${each.key}"
  }
}