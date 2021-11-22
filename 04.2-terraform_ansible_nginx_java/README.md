# rodar playbook no ansible
ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key ~/.ssh/id_rsa

# acesso ssh maquina
ssh -i ~/.ssh/id_rsa ubuntu@ec2-54-94-98-68.sa-east-1.compute.amazonaws.com 




 