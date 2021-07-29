terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.51.0"
    }
  }
}

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"

  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "mentee"
}
