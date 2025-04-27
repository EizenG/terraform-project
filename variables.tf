# ----------------------------------------------------------
# Variables du module
# ----------------------------------------------------------

variable "namespace" {
  description = "Préfixe utilisé pour nommer toutes les ressources"
  type        = string

  validation {
    condition     = length(var.namespace) >= 3 && length(var.namespace) <= 20 && can(regex("^[a-z][a-z0-9-]*$", var.namespace))
    error_message = "Le namespace doit contenir entre 3 et 20 caractères, commencer par une lettre minuscule et ne contenir que des lettres minuscules, chiffres et tirets."
  }
}

variable "vpc_cidr_block" {
  description = "Bloc CIDR pour le VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "Le bloc CIDR du VPC doit être au format valide (ex: 10.0.0.0/16)."
  }
}

variable "subnet_cidr_block" {
  description = "Bloc CIDR pour le sous-réseau public"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_block))
    error_message = "Le bloc CIDR du sous-réseau doit être au format valide (ex: 10.0.1.0/24)."
  }
}

variable "map_public_ip" {
  description = "Attribuer automatiquement une IP publique aux instances du sous-réseau"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "Zone de disponibilité pour le déploiement des ressources"
  type        = string
}

variable "common_tags" {
  description = "Tags communs à appliquer à toutes les ressources"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.common_tags) <= 30
    error_message = "AWS permet un maximum de 50 tags par ressource."
  }
}

variable "key_name" {
  description = "Nom de la paire de clés SSH à créer. Si null, aucune paire de clés ne sera créée"
  type        = string
  default     = null

  validation {
    condition     = var.key_name == null || (length(var.key_name) >= 3 && length(var.key_name) <= 20 && can(regex("^[a-zA-Z0-9_-]+$", var.key_name)))
    error_message = "Le nom de la clé SSH doit être null ou contenir entre 3 et 20 caractères alphanumériques, underscores ou tirets."
  }
}

variable "save_private_key_to_file" {
  description = "Enregistrer la clé privée SSH générée sur le disque local"
  type        = bool
  default     = false
}

variable "allowed_ssh_cidrs" {
  description = "Liste des blocs CIDR autorisés à se connecter en SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length([for cidr in var.allowed_ssh_cidrs : cidr if can(cidrnetmask(cidr))]) == length(var.allowed_ssh_cidrs)
    error_message = "Tous les éléments de allowed_ssh_cidrs doivent être des blocs CIDR valides."
  }
}

variable "additional_ingress_rules" {
  description = "Règles d'entrée supplémentaires pour le groupe de sécurité"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.additional_ingress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      rule.to_port >= rule.from_port &&
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol) &&
      length(rule.description) > 0 &&
      length([for cidr in rule.cidr_blocks : cidr if can(cidrnetmask(cidr))]) == length(rule.cidr_blocks)
    ])
    error_message = "Les règles d'entrée doivent avoir des ports valides (0-65535), un protocole valide (tcp, udp, icmp, -1), une description et des CIDR valides."
  }
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser pour l'instance EC2"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2 à déployer"
  type        = string
  default     = "t2.micro"
}

variable "user_data" {
  description = "Script de démarrage pour l'instance EC2"
  type        = string
  default     = ""
}

variable "instance_tags" {
  description = "Tags spécifiques à appliquer à l'instance EC2"
  type        = map(string)
  default     = {}
}
