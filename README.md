# 🚀 Terraform Module: AWS EC2 Instance with VPC
[![Terraform Version](https://img.shields.io/badge/Terraform-1.11.4+-blue.svg)](https://www.terraform.io/)
[![Pre-commit Enabled](https://img.shields.io/badge/Pre--commit-Enabled-green)](https://pre-commit.com/)
[![Security Scan](https://img.shields.io/badge/Security-Scanned%20by%20Trivy-orange)](https://aquasecurity.github.io/trivy/)
---
## 📚 Introduction
Welcome! 👋  
This Terraform module provides a **secure**, **tested**, and **compliant** way to deploy a **VPC** with an **EC2 instance** on AWS using best DevOps practices.  
It is **modular**, **reusable**, and designed to be easily integrated into larger Infrastructure-as-Code projects.
This module includes:
- Complete VPC configuration with Internet Gateway
- Secure SSH access management
- Public subnet with proper routing
- EC2 instance provisioning with customizable settings
---
## 📦 Features
✅ Secure credential handling  
✅ VPC and EC2 Instance provisioning  
✅ Automatic documentation with terraform-docs  
✅ Ensure secure Terraform configuration with Trivy 
✅ Infrastructure testing with Terratest  
✅ CI-like local pipeline using pre-commit hooks
---
## 📑 Requirements
The following tools must be installed before using this module:
- [Terraform](https://www.terraform.io/) >= 1.11.4
- [Terraform-docs](https://terraform-docs.io/user-guide/installation/) >= 0.15.0
---
## ⚙️ Providers
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## ⚙️ Providers
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.96.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## 🧩 Modules
## Modules

No modules.

## 🏗️ Resources
## Resources

| Name | Type |
|------|------|
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_key_pair.ssh_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route.internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.instance_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [local_sensitive_file.private_key_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## 🎛️ Inputs
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ID de l'AMI à utiliser pour l'instance EC2 | `string` | n/a | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Zone de disponibilité pour le déploiement des ressources | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Préfixe utilisé pour nommer toutes les ressources | `string` | n/a | yes |
| <a name="input_additional_ingress_rules"></a> [additional\_ingress\_rules](#input\_additional\_ingress\_rules) | Règles d'entrée supplémentaires pour le groupe de sécurité | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>    description = string<br/>  }))</pre> | `[]` | no |
| <a name="input_allowed_ssh_cidrs"></a> [allowed\_ssh\_cidrs](#input\_allowed\_ssh\_cidrs) | Liste des blocs CIDR autorisés à se connecter en SSH | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags communs à appliquer à toutes les ressources | `map(string)` | `{}` | no |
| <a name="input_instance_tags"></a> [instance\_tags](#input\_instance\_tags) | Tags spécifiques à appliquer à l'instance EC2 | `map(string)` | `{}` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type d'instance EC2 à déployer | `string` | `"t2.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Nom de la paire de clés SSH à créer. Si null, aucune paire de clés ne sera créée | `string` | `null` | no |
| <a name="input_map_public_ip"></a> [map\_public\_ip](#input\_map\_public\_ip) | Attribuer automatiquement une IP publique aux instances du sous-réseau | `bool` | `true` | no |
| <a name="input_save_private_key_to_file"></a> [save\_private\_key\_to\_file](#input\_save\_private\_key\_to\_file) | Enregistrer la clé privée SSH générée sur le disque local | `bool` | `false` | no |
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | Bloc CIDR pour le sous-réseau public | `string` | `"10.0.1.0/24"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Script de démarrage pour l'instance EC2 | `string` | `""` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | Bloc CIDR pour le VPC | `string` | `"10.0.0.0/16"` | no |

## 📤 Outputs
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Zone de disponibilite ou l'instance a ete deploye |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ID de l'instance EC2 |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | Adresse IP privée de l'instance EC2 |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | Adresse IP publique de l'instance EC2 |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID du groupe de sécurité de l'instance |
| <a name="output_ssh_key_name"></a> [ssh\_key\_name](#output\_ssh\_key\_name) | Nom de la paire de clés SSH créée |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | Clé privée SSH générée (sensible) |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | ID du sous-réseau public |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID du VPC créé par le module |
<!-- END_TF_DOCS -->
---
---
## 🚀 Usage Example
```hcl
module "aws_instance" {
  source = "path-to-module"
  
  namespace          = "example-app"
  vpc_cidr_block     = "10.0.0.0/16"
  subnet_cidr_block  = "10.0.1.0/24"
  availability_zone  = "us-west-2a"
  
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.micro"
  key_name           = "my-key"
  
  # Additional security group rules
  additional_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]

  # Common tags for all resources
  common_tags = {
    Environment = "development"
    Project     = "example"
    Terraform   = "true"
  }
}

```
---

## 🧪 Testing
This module includes Terratest configurations for automated infrastructure testing:

```bash
# Navigate to the test directory
cd test

# Run the tests
go test -v -timeout 30m
```
---
## 🛠️ Development
### Pre-commit Hooks
This repository uses pre-commit hooks to ensure code quality and consistency:

```bash
# Install pre-commit
pip install pre-commit

# Install the git hooks
pre-commit install

# Run the hooks against all files
pre-commit run --all-files
```

### Documentation Generation
To update this README with the latest module information:

```bash
# Install terraform-docs
# See: https://terraform-docs.io/user-guide/installation/

# Generate/update documentation
terraform-docs markdown table --output-file README.md .
```
---

## 📄 License
This project is open source