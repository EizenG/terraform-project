# ----------------------------------------------------------
# Module Terraform pour déployer un VPC AWS et une instance EC2
# Ce module crée l'infrastructure réseau nécessaire ainsi qu'une instance EC2
# avec gestion sécurisée des clés SSH.
# ----------------------------------------------------------

# ----------------------------------------------------------
# Ressources réseau - VPC et composants associés
# ----------------------------------------------------------

/**
 * Réseau VPC pour isoler l'infrastructure
 */
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-vpc"
    }
  )
}

/**
 * Passerelle Internet pour permettre la connectivité avec Internet
 */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-igw"
    }
  )
}

/**
 * Sous-réseau public pour les ressources accessibles depuis Internet
 * Permet d'attribuer automatiquement des IPs publiques aux instances lancées
 */
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = var.map_public_ip
  availability_zone       = var.availability_zone
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-public-subnet"
      Type = "Public"
    }
  )
}

/**
 * Table de routage pour le sous-réseau public
 */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-public-route-table"
    }
  )
}

/**
 * Route par défaut vers Internet via la passerelle Internet
 */
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

/**
 * Association entre le sous-réseau public et sa table de routage
 */
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ----------------------------------------------------------
# Ressources de sécurité - Clés SSH et groupe de sécurité
# ----------------------------------------------------------

/**
 * Génération d'une paire de clés SSH pour l'accès sécurisé à l'instance
 */
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/**
 * Sauvegarde conditionnelle de la clé privée sur le disque local
 * Utilisé principalement pour les environnements de développement
 */
resource "local_sensitive_file" "private_key_file" {
  count                = var.save_private_key_to_file ? 1 : 0
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/${var.namespace}-id_rsa"
  file_permission      = "0600"
  directory_permission = "0700"
}

/**
 * Enregistrement de la clé publique dans AWS
 * Créé uniquement si un nom de clé est spécifié
 */
resource "aws_key_pair" "ssh_key" {
  count      = var.key_name != null ? 1 : 0
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-key-pair"
    }
  )
}

/**
 * Groupe de sécurité pour contrôler l'accès SSH à l'instance
 */
resource "aws_security_group" "instance_sg" {
  name        = "${var.namespace}-sg"
  description = "Security group for ${var.namespace} instance"
  vpc_id      = aws_vpc.vpc.id

  # Règle d'entrée pour SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
    description = "SSH access from specified CIDR blocks"
  }

  # Règles d'entrée supplémentaires basées sur la variable
  dynamic "ingress" {
    for_each = var.additional_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  # Règle de sortie - autorise tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-security-group"
    }
  )
}

# ----------------------------------------------------------
# Instance EC2
# ----------------------------------------------------------

/**
 * Instance EC2 avec configuration conditionnelle de la clé SSH
 */
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  availability_zone           = var.availability_zone
  key_name                    = var.key_name != null ? aws_key_pair.ssh_key[0].key_name : null
  associate_public_ip_address = var.map_public_ip
  

  # Script de démarrage conditionnel
  user_data = var.user_data != "" ? var.user_data : null
  
  tags = merge(
    var.common_tags,
    {
      Name = "${var.namespace}-instance"
    },
    var.instance_tags
  )
}