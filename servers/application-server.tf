
resource "aws_instance" "web-app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  vpc_security_group_ids      = [aws_security_group.application_server.id]
  key_name                    = "on-prem-key"
  subnet_id                   = data.aws_subnet.public.id
  associate_public_ip_address = true
  user_data                   = templatefile("app-user-data.sh.tpl",{
    db_private_ip = aws_instance.db-server.private_ip,
    mysql_root_password = var.mysql_root_password
  })
  tags = {
    Name = "application-server"
  }

}

resource "aws_network_interface" "web_app_eni" {
  subnet_id       = data.aws_subnet.public.id
  security_groups = [aws_security_group.application_server.id]
}

resource "aws_eip" "application_server_eip" {
  instance = aws_instance.web-app.id
  vpc      = true

}



resource "aws_security_group" "application_server" {
  name        = "application-server"
  description = "Allow connection for  inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "application-server"
  }
}
