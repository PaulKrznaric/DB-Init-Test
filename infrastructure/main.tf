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
  engine_version      = "14"
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

resource "null_resource" "setup_db" {
  depends_on = [aws_db_instance.db_server]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "/tmp"
    command     = <<-EOT
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-6-x86_64/pgdg-redhat-repo-latest.noarch.rpm
            sudo yum install postgresql -y
            export PGPASSWORD = ${random_password.password.result}
             psql --host=${aws_db_instance.db_server.endpoint} --port=5432 --username=devadmin --dbname=pgdb001 < setup.psql
            EOT      
  }
}



