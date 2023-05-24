data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }


  owners = ["099720109477"] # Canonical
}

# data "aws_vpc" "talent_academy" {
#   filter {
#     name   = "tag:Name"
#     values = ["lab-vpc"]
#   }

# }

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["on-prem-vpc-public-eu-west-1a"]
  }

}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Environment"
    values = ["test"]
  }

}


data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["on-prem-vpc-private-eu-west-1a"]
  }

}


# data "aws_security_group" app-server-sg {
#     filter {
#     name   = "tag:Name"
#     values = ["application-server"]
#   }
# }