# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl = "private"
}

# Create an EC2 security group to allow SSH access
resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg_"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch two EC2 instances using Amazon Linux 2 AMI
resource "aws_instance" "example_instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count = 2
  security_groups = [aws_security_group.instance_sg.id]

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo 'Hello World from ${self.public_ip}' | sudo tee /var/www/html/index.html"
    ]
  }
}
