variable "aws_region" {
  description = "Région AWS"
  type = string
}

variable "aws_profile" {
  description = "Profile aws pour les credentials"
  type = string
}

variable "namespace" {
  description = "namespace requis par le module"
  type = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR BLOCK"
  type = string
}

variable "subnet_cidr_block" {
  description = "Bloc CIDR pour le sous-réseau public"
  type = string
}

variable "map_public_ip" {
  description = "Attribuer automatiquement une IP publique aux instances du sous-réseau"
  type        = bool
}

variable "availability_zone" {
  description = "Zone de disponibilité pour le déploiement des ressources"
  type        = string
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser pour l'instance EC2"
  type        = string
}

variable "key_name" {
  description = "Nom de la paire de clés SSH à créer"
  type        = string
}

variable "save_private_key_to_file" {
  description = "Enregistrer la clé privée SSH générée sur le disque local"
  type        = bool
}

variable "common_tags" {
  description = "Tags communs à appliquer à toutes les ressources"
  type        = map(string)
}

variable "instance_tags" {
  description = "Tags spécifiques à appliquer à l'instance EC2"
  type        = map(string)
}