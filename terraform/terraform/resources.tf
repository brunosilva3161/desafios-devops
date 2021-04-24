resource "aws_key_pair" "idwall_challenge_key" {
  key_name   = "idwall_challenge_key"
  public_key = file("~/idwall-challenge.pub")
}

resource "aws_security_group" "idwall_challenge" {
  name        = "idwall_challenge"
  description = "idwall challenge required ports"

  ingress {
    cidr_blocks = [
      var.ssh_ip_range
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Name = "idwall challenge"
  }
}

resource "aws_instance" "idwall_challenge" {
  associate_public_ip_address = true
  ami                         = "ami-0adb6517915458bdb" # Debian 10 (Buster) AMI - Only works in us-east-1 region.
  key_name                    = aws_key_pair.idwall_challenge_key.key_name
  instance_type               = "t2.micro"
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    tags = {
      Name = "idwall challenge"
    }
  }
  vpc_security_group_ids = [
    aws_security_group.idwall_challenge.id,
  ]
  tags = {
    Name = "idwall challenge"
  }
  depends_on = [
    aws_security_group.idwall_challenge,
  ]
}

output "public_ip" {
  value = aws_instance.idwall_challenge.public_ip
}
