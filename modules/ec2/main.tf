locals {
  default_ami              = data.aws_ami.default_ami.id
  sonar_ami_id             = var.sonar_ami != null ? var.sonar_ami : local.default_ami
  sonar_instance_type      = var.sonar_instance_type != null ? var.sonar_instance_type : lookup(var.default_instance_type_map, "sonar", null)
  subnet_id                = var.subnet_id != null ? var.subnet_id : data.aws_subnet.default_private_subnet.id
  bastion_ami_id           = var.bastion_ami_id != null ? var.bastion_ami_id : local.default_ami
  public_bastion_subnet_id = var.bastion_subnet_id != null ? var.bastion_subnet_id : data.aws_subnet.default_public_subnet.id
  bastion_instance_type    = var.bastion_host_instance_type != null ? var.bastion_host_instance_type : lookup(var.default_instance_type_map, "bastion", null)
}

data "aws_ami" "default_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]

}

data "aws_subnet" "default_private_subnet" {
  id = "subnet-0dd64dfa23b1ee2ab"
}

data "aws_subnet" "default_public_subnet" {
  id = "subnet-0523f968e75c2d3fd"
}


############################################### SONAR server config ###############################################
# RSA key of size 4096 bits
resource "tls_private_key" "sonar_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "sonar_pem" {
  key_name   = "sonar"
  public_key = tls_private_key.sonar_key.public_key_openssh
}

resource "local_file" "sonar_key_pem" {
  content  = tls_private_key.sonar_key.private_key_openssh
  filename = "${path.module}/sonar_key.pem"
}


resource "aws_instance" "sonar" {
  ami                    = local.sonar_ami_id
  instance_type          = local.sonar_instance_type
  subnet_id              = local.subnet_id
  key_name               = aws_key_pair.sonar_pem.key_name
  vpc_security_group_ids = var.sonar_sg_id_list
  tags = merge({
    Name = "${var.domain_name}-SonaQube-server"
    },
    var.default_tags
  )
}

############################################### Bastion host config ###############################################
resource "tls_private_key" "bastion_host_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_host" {
  key_name   = "bastion_host"
  public_key = tls_private_key.bastion_host_key.public_key_openssh
}

resource "local_file" "bastion_host_key_pem" {
  content  = tls_private_key.bastion_host_key.private_key_openssh
  filename = "${path.module}/bastion_host_key.pem"
}

resource "aws_instance" "bastion_host" {
  ami                    = local.bastion_ami_id
  instance_type          = local.bastion_instance_type
  subnet_id              = local.public_bastion_subnet_id
  key_name               = aws_key_pair.bastion_host.key_name
  vpc_security_group_ids = var.bastion_sg_id_list
  tags = merge({
    Name = "${var.domain_name}-bastion-host"
    },
    var.default_tags
  )
}