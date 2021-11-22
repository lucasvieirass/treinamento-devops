terraform {
  required_version = ">= 0.12" # colocando compatibilidade do terraform para 0.12
}

resource "aws_instance" "web" {
  subnet_id     = "subnet-0fc6abd81bbb30292"
  ami= "ami-054a31f1b3bf90920"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-0064d19cc3955d06d"]
  associate_public_ip_address = true
  key_name = 
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  
  tags = {
    Name = "${var.nome}",
  }
}