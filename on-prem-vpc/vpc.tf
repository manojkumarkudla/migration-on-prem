module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "on-prem-vpc"
  cidr = "192.168.0.0/16"

  azs             = ["eu-west-1a"]
  private_subnets = ["192.168.2.0/24"]
  public_subnets  = ["192.168.1.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "test"
  }
}