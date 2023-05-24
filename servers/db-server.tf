
resource "aws_instance" "db-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  vpc_security_group_ids      = [aws_security_group.application_server.id]
  key_name                    = "on-prem-key"
  subnet_id                   = data.aws_subnet.private.id
  user_data = templatefile("db-user.sh.tpl",{
    app_private_ip = aws_network_interface.web_app_eni.private_ip,
    mysql_root_password = var.mysql_root_password
  })


  tags = {
    Name = "db-server"
  }

}




resource "aws_security_group" "db_server" {
  name        = "db-server"
  description = "Allow connection for  inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "allow port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.application_server.id]
  }

  # ingress {
  #   description = "allow port 22"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "db-server"
  }
}
