provider "aws" {
  region = "sa-east-1"
}
resource "aws_instance" "web" {
  count = 3
  subnet_id     = "subnet-0fc6abd81bbb30292"
  ami= "ami-054a31f1b3bf90920"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  root_block_device {
    encrypted = true
    volume_size = 30
  }
  tags = {
    Name = "ec2-lucasteste-tf"
  }
}

# https://www.terraform.io/docs/language/values/outputs.html

output "instance_ip_add" {
  value = [
          for key, item in aws_instance.web:
                "${item.private_ip} - ${item.public_dns}"
          ]
  description = "Mostra os IPs publicos e privados da maquina criada."
}

# /////