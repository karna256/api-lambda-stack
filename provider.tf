terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Name"    = "terraform-default"
      "Creator" = "Ankit"
      "Project" = "Training"
    }
  }
}