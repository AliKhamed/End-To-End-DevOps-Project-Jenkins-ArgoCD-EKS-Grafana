resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Jenkins_server_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  count = var.sg["ingress_count"][0]["count"]
  security_group_id = aws_security_group.ec2_sg.id
  from_port         = var.sg["ingress_rule"][count.index]["port"]
  to_port           = var.sg["ingress_rule"][count.index]["port"]
  ip_protocol       = var.sg["ingress_rule"][count.index]["protocol"]
  cidr_ipv4         = var.sg["ingress_rule"][count.index]["cidr"]
  tags = {
    Name = "ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "ec2_jenkins" {
  ami                       = var.ami
  instance_type             = var.instance_type
  subnet_id                 = var.subnet_id
  associate_public_ip_address = true
  security_groups           = [aws_security_group.ec2_sg.id]
  key_name                  = var.key_name
  tags = {
    Name = "Jenkins_server"
  }
}

resource "aws_ebs_volume" "jenkins_volume" {
  availability_zone = aws_instance.ec2_jenkins.availability_zone
  size              = var.volume_size

  tags = {
    Name = "Jenkins_volume"
  }
}

resource "aws_volume_attachment" "jenkins_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.jenkins_volume.id
  instance_id = aws_instance.ec2_jenkins.id
}






# resource "aws_security_group" "ec2_sg" {
#   vpc_id      = var.vpc_id
#   tags = {
#     Name = "Jenkins_server_sg"
#   }
# }
# resource "aws_vpc_security_group_ingress_rule" "ingress" {
#   count = var.sg["ingress_count"][0]["count"]
#   security_group_id = aws_security_group.ec2_sg.id
#   from_port         = var.sg["ingress_rule"][count.index]["port"]
#   to_port           = var.sg["ingress_rule"][count.index]["port"]
#   ip_protocol       = var.sg["ingress_rule"][count.index]["protocol"]
#   cidr_ipv4         = var.sg["ingress_rule"][count.index]["cidr"]
#   tags = {
#     Name = "ingress"
#   }
# }

# resource "aws_vpc_security_group_egress_rule" "egress" {
#   security_group_id = aws_security_group.ec2_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" 
# }
# resource "aws_instance" "ec2_jenkins" {
#   ami             = var.ami
#   instance_type   = var.instance_type
#   subnet_id       = var.subnet_id
#   associate_public_ip_address = true
#   security_groups = [aws_security_group.ec2_sg.id]
#   key_name = var.key_name
#   tags = {
#     Name = "Jenkins_server"
#   }
# }
