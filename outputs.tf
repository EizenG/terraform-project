# ----------------------------------------------------------
# Outputs du module
# ----------------------------------------------------------

output "vpc_id" {
  description = "ID du VPC créé par le module"
  value       = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "ID du sous-réseau public"
  value       = aws_subnet.public.id
}

output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.ec2_instance.id
}

output "instance_public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "Adresse IP privée de l'instance EC2"
  value       = aws_instance.ec2_instance.private_ip
}

output "availability_zone" {
  description = "Zone de disponibilite ou l'instance a ete deploye"
  value       = aws_instance.ec2_instance.availability_zone
}

output "security_group_id" {
  description = "ID du groupe de sécurité de l'instance"
  value       = aws_security_group.instance_sg.id
}

output "ssh_key_name" {
  description = "Nom de la paire de clés SSH créée"
  value       = var.key_name != null ? aws_key_pair.ssh_key[0].key_name : null
}

output "ssh_private_key" {
  description = "Clé privée SSH générée (Attention sensible)"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}


