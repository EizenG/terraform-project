aws_region = "us-east-1"
aws_profile = "terraform-user"
namespace = "junior"
vpc_cidr_block = "10.0.0.0/16"
subnet_cidr_block = "10.0.1.0/24"
map_public_ip = true
availability_zone = "us-east-1a"
ami_id = "ami-0e449927258d45bc4"
key_name = "junior-terraform-key"
save_private_key_to_file = true

common_tags = {
    Project = "terraform-demo"
    Owner   = "Junior"
  }
  
instance_tags = {
    Role = "web-server"
  }