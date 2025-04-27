provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "infra_base" {
  source = "./modules/terraform-aws-ec2-instance"

  namespace                = var.namespace
  vpc_cidr_block           = var.vpc_cidr_block
  subnet_cidr_block        = var.subnet_cidr_block
  map_public_ip            = var.map_public_ip
  availability_zone        = var.availability_zone
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  save_private_key_to_file = var.save_private_key_to_file

  common_tags = var.common_tags

  instance_tags = var.instance_tags
}
