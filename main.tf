# Configure the AWS provider
provider "aws" {
  region = "us-west-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "somejigilaffin_bucket" {
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

# Launch two Ubuntu EC2 instances
resource "aws_instance" "lafiaji_instance" {
  ami = "ami-0c55b159cbfafe1f0"
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
