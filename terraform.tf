terraform {

  backend "s3" {
    region         = "eu-central-1"
    key            = "terraform.tfstate"
    bucket         = "big-platform-tfm"
    dynamodb_table = "terraform-locks"
  }
}