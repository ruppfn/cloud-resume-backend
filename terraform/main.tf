locals {
  region     = "us-east-2"
  account_id = data.aws_caller_identity.current.account_id
  build_path = "../build"
}

terraform {
  backend "s3" {
    key    = "cloud-resume/backend/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = local.region
}
