# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "somffin_bucket" {
  bucket = "frontier667-bucket"


# Launch two Ubuntu EC2 instances
resource "aws_instance" "lafiaji_instance" {
  ami = "ami-0d361301d8f7067d5"
  instance_type = "t2.micro"
  count = 2
}
