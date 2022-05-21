terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"
    }
  }

  required_version = ">=0.14.9"
}

provider "aws" {
  profile = "emrdev"
  region  = "us-east-1"
}

provider "random" {
  #configuration options
}

resource "random_password" "password" {
  length           = 20
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "db_server" {
  allocated_storage   = 20
  identifier          = "dev-db"
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = "db.t3.micro"
  name                = "pgdb001"
  username            = "devadmin"
  password            = random_password.password.result
  skip_final_snapshot = true
  publicly_accessible = true

  tags = {
    Name = "ExampleDBDeployment"
  }
}

output "db_password" {
  value     = random_password.password.result
  sensitive = true
}

