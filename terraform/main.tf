locals {
  region           = "us-east-2"
  account_id       = data.aws_caller_identity.current.account_id
  build_path       = "../build"
  base_domain_name = "${var.environment == "develop" ? "dev." : ""}frupp.com.ar"
  domain_name      = "api.${local.base_domain_name}"
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
