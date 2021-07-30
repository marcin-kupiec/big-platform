terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }

  backend "s3" {
    profile = "mentee"
    region  = "eu-central-1"
    key     = "terraform.tfstate"
    bucket  = "big-platform-config-bucket"
  }
}
