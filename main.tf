resource "aws_sns_topic" "test_topic" {
  provider = aws.eu-central-1
  name     = "topic-test"
}
