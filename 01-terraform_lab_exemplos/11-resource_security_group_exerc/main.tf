provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name = "nova-chave" # Nome da Key gerada pelo ssk-keygem e upada na AWS
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

 # output "instance_ip" {
 # value = [
 #          aws_instance.web.public_ip, 
 #          aws_instance.web.public_dns
 #         ]
 # description = "Mostra os IPs publicos e privados da maquina criada."
 # }

}