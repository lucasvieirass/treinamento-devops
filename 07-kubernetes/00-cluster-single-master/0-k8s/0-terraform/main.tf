provider "aws" {
  region = "sa-east-1"
}

# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com" # outra opção "https://ifconfig.me"
# }

resource "aws_instance" "maquina_master" {
  associate_public_ip_address = true
  subnet_id     = "subnet-0fc6abd81bbb30292"
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.large"
  key_name      = "nova-chave"
  tags = {
    Name = "k8s-master"
  }
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  
  vpc_security_group_ids = [aws_security_group.acessos_master_single_master.id]
  depends_on = [
    aws_instance.workers,
  ]
}

resource "aws_instance" "workers" {
  associate_public_ip_address = true
  subnet_id     = "subnet-0fc6abd81bbb30292"
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.medium"
  key_name      = "nova-chave"
  tags = {
    Name = "k8s-node-${count.index + 1}"
  }
  root_block_device {
    encrypted = true
    volume_size = 8
  }
  vpc_security_group_ids = [aws_security_group.acessos_workers_single_master.id]
  count         = 3
}

resource "aws_security_group" "acessos_master_single_master" {
  name        = "acessos_master_single_master"
  description = "acessos_master_single_master inbound traffic"
  vpc_id = "vpc-060cb014cb52f7bc4"


  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [
        "sg-0b4cb69e6e5085790",
      ]
      self             = false
      to_port          = 0
    },
    {
      cidr_blocks      = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 65535
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_master_single_master"
  }
}


resource "aws_security_group" "acessos_workers_single_master" {
  name        = "acessos_workers_single_master"
  description = "acessos_workers_single_master inbound traffic"
  vpc_id = "vpc-060cb014cb52f7bc4"

  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = null,
      security_groups: null,
      self: null
    },
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = [
        "${aws_security_group.acessos_master_single_master.id}",
      ]
      self             = false
      to_port          = 0
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids = null,
      security_groups: null,
      self: null,
      description: "Libera dados da rede interna"
    }
  ]

  tags = {
    Name = "acessos_workers_single_master"
  }
}


# terraform refresh para mostrar o ssh
output "maquina_master" {
  value = [
    "master - ${aws_instance.maquina_master.public_ip} - ssh -i ~/.ssh/lucas.pem ubuntu@${aws_instance.maquina_master.public_dns}",
    "sg worker - ${aws_security_group.acessos_workers_single_master.id}"    
    ]
}

# terraform refresh para mostrar o ssh
output "maquina_workers" {
  value = [
    for key, item in aws_instance.workers :
      "worker ${key+1} - ${item.public_ip} - ssh -i ~/.ssh/lucas.pem ubuntu@${item.public_dns}"
    ]    
}