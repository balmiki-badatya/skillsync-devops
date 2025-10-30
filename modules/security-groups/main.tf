resource "aws_security_group" "sonar_sg" {
  name        = "${var.env}-sonar-sg"
  description = "Security group for sonar host"
  tags = merge({
    Name = "${var.env}-sonar-sg"
    },
    var.default_tags
  )
}

resource "aws_vpc_security_group_vpc_association" "example" {
  security_group_id = aws_security_group.sonar_sg.id
  vpc_id            = lookup(var.vpc_details, "vpc_id", null)
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_inside_vpc" {
  security_group_id = aws_security_group.sonar_sg.id
  cidr_ipv4         = lookup(var.vpc_details, "vpc_cidr", null)
  from_port         = 22
  ip_protocol       = "ssh"
  to_port           = 22
  depends_on        = [aws_security_group.sonar_sg]
}

# resource "aws_vpc_security_group_ingress_rule" "allow_https_form_alb" {
#   security_group_id            = aws_security_group.sonar_sg.id
#   referenced_security_group_id = lookup(var.vpc_details, "vpc_cidr", null) # change it to alb sg
#   from_port                    = 443
#   ip_protocol                  = "tcp"
#   to_port                      = 443
#   depends_on                   = [aws_security_group.sonar_sg]
# }

resource "aws_vpc_security_group_egress_rule" "default_egress" {
  security_group_id = aws_security_group.sonar_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  depends_on        = [aws_security_group.sonar_sg]
}
#######################################################################################################
########################################### Bastion host SG ###########################################

resource "aws_security_group" "bastion_sg" {
  name        = "${var.env}-bastion-sg"
  description = "Security group for bastion host"
  tags = merge({
    Name = "${var.env}-bastion-sg"
    },
    var.default_tags
  )
}

resource "aws_vpc_security_group_vpc_association" "bastion_sg_vpc_association" {
  security_group_id = aws_security_group.bastion_sg.id
  vpc_id            = lookup(var.vpc_details, "vpc_id", null)
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  for_each          = var.ssh_ipv4_set
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = each.key
  from_port         = lookup(var.port_map, "ssh", 22)
  ip_protocol       = "ssh"
  to_port           = lookup(var.port_map, "ssh", 22)
  depends_on        = [aws_security_group.bastion_sg]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = lookup(var.port_map, "all", -1) # semantically equivalent to all ports
  depends_on        = [aws_security_group.bastion_sg]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = lookup(var.port_map, "all", -1) # semantically equivalent to all ports
  depends_on        = [aws_security_group.bastion_sg]
}





