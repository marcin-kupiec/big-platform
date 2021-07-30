provider "aws" {
  profile = "mentee"
  alias   = "eu-central-1"
  region  = "eu-central-1"
}

resource "aws_sns_topic" "test_topic" {
  provider = aws.eu-central-1
  name     = "topic-test"
}
