terraform {
  backend "s3" {
    bucket         = "manoj-migrationlab-tfstate"
    key            = "talent-academy/on-prem/terraform.tfstates"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-db"
  }
}