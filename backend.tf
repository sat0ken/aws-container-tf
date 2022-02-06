terraform {
  backend "s3" {
    bucket = "awsiotdata"
    key    = "terraform/tf.state"
    region = "ap-northeast-1"
  }
}