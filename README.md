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

## ⚙️ Providers
## Providers


## 🧩 Modules
## Modules

No modules.

## 🏗️ Resources
## Resources


## 🎛️ Inputs
## Inputs


## 📤 Outputs
## Outputs

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

---

## 📄 License
This project is open source