provider "aws" {
  region = "sa-east-1"
}

resource "aws_key_pair" "chave_key" {
  key_name   = "chave_key_lucassouza_terraform"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDreGlMCQpqQXiO0yv4MxQt0vEoODPyrP3Kv6ylUGM/u1HCARlINtFWLMsLcbfQU9LJYceD6c9nxoPr1frzYRWCLb19LnsJ43I++ABCBIF6X/hOZLBYdRkUDr77VsAMtMyUCNEv8Fk1go8M3V47gEw3+YGI0zuEHy66ELsaZtwdMJsfaujXaTmVY923/0zvzls9YTBPeXew9znj0iMG7FdGUhMYrMHkvAvo8UL0gJgi2EDizzZNO1gaq9jLYvz48/kZDgy7c7upkzAnPQPnOxQ4ycMy3G1YyO+fXlGAO9668a3kHmWfr+M4zw02wEgGvOSMshM00q88JBDBfI8SMi37qqhbt2YeQzOxWrNJfdRbUgGULZssMaGxT1tjHBIuT2fMDJlwZ/V5BHxe0lzz6M8dzD8QOFM7bRqtkywvV0pdCVqSz1jUQavfVT1KgdKoNRMrtAIQuhI8ALX4I99lGzhmVB4DeT2j0C9EtVf4Hq1nmzokOV/dTwfH2oteTBXPh08= ubuntu@ip-10-40-19-107"
}

resource "aws_instance" "web" {
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name = "chave_key_lucassouza_terraform"
  associate_public_ip_address = true
  
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  tags = {
    Name = "Minha Maquina Simples EC2"
  }
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_lucassouza.id}"]
  subnet_id     = "subnet-0fc6abd81bbb30292"
}

output "instance_ip" {
value = [
         aws_instance.web.public_ip, 
         aws_instance.web.public_dns
        ]
description = "Mostra os IPs publicos e privados da maquina criada."
}