provider "aws" {
  shared_credentials_file = "/Users/dell/.aws/creds"
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "Test VPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Test Subnet"
  }
}

resource "aws_instance" "web" {
  ami               = "ami-08f63db601b82ff5f"
  availability_zone = "ap-south-1a"
  instance_type     = "t2.micro"
  subnet_id   = aws_subnet.my_subnet.id
  private_ip = "172.16.10.100"
  user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                echo "<h1>Sample Webserver ITC COE Server" | sudo tee  /var/www/html/index.html
  EOF

  tags = {
    Name = "TestServer"
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 1
}
