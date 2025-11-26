# Exercice Phase 5 : Terraform pour infrastructure de déploiement

## Exercice à réaliser

Créez des scripts Terraform pour provisionner l'infrastructure de déploiement (serveurs, réseaux).

## Correction complète

```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name = "cicd-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "cicd-subnet"
  }
}

# Security Group
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group for application"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.app.id]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
  EOF
  
  tags = {
    Name = "app-server"
  }
}

# Variables
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

# Outputs
output "instance_ip" {
  value = aws_instance.app.public_ip
}

output "instance_id" {
  value = aws_instance.app.id
}
```

## Explications détaillées

**provider "aws"** : Configuration du provider AWS

**resource "aws_vpc"** : Crée un VPC (réseau virtuel)

**resource "aws_subnet"** : Crée un sous-réseau

**resource "aws_security_group"** : Configure le firewall

**resource "aws_instance"** : Crée une instance EC2

**user_data** : Script d'initialisation de l'instance

**variables** : Paramètres configurables

**outputs** : Valeurs exportées

## Utilisation

```bash
terraform init
terraform plan -var="ami_id=ami-xxx"
terraform apply
```

## Vérification

Vérifiez que :
- Le VPC est créé
- L'instance est démarrée
- L'IP publique est accessible

