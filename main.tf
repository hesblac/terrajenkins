# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "somffin_bucket" {
  bucket = "frontier667-bucket"
}

# Create an EC2 security group to allow SSH access
resource "aws_security_group" "instance_sg" {
  name_prefix = "instance_sg_"
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch two Ubuntu EC2 instances
resource "aws_instance" "lafiaji_instance" {
  ami = "ami-0d361301d8f7067d5"
  instance_type = "t2.micro"
  count = 2
  key_name = "mykey"
  security_groups = [aws_security_group.instance_sg.id]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "hesblac"
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "echo 'Hello World from ${self.public_ip}' | sudo tee /var/www/html/index.html"
    ]
  }
}
