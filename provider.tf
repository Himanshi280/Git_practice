terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      APPLICATION_NAME = "AWS ACC"
      PROJECT_NAME     = "AWS ACC"
      CLIENT_NAME      = "CEQ-INTERNAL"
      DEPARTMENT_NAME  = "Observability"
      OWNER_NAME       = "himanshi.soni@cloudeq.com"
      SOW_NUMBER       = "Internal"
      END_DATE         = "14-11-2024"
      START_DATE       = "14-11-2024"
    }
  }
}