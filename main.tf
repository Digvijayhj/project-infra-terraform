provider "aws" {
  region = var.region
}

resource "aws_security_group" "sg_web" {
  name        = "game-room-fe-sg"
  description = "Allow HTTP for game room frontend"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "vite_app" {
  ami           	      = "ami-075686beab831bb7f"  # Official Ubuntu 22.04 LTS
  instance_type 	      = "t2.micro"
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  associate_public_ip_address = true
  user_data                   = file("install-nginx.sh")

  tags = {
    Name = "game-room-dashboard-fe"
  }
}

resource "aws_route53_record" "vite_record" {
  count   = var.zone_id == "" ? 0 : 1
  zone_id = var.zone_id
  name    = "vite"
  type    = "A"
  ttl     = 300
  records = [aws_instance.vite_app.public_ip]
}
