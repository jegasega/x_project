module "identity" {
  source    = "../../../modules/ec2-mgmt-host"
  name      = "identity-private-${local.environment}-mgmt"
  vpc_id    = data.aws_vpc.identity.id
  subnet_id = data.aws_subnet.identity.id
  tags      = local.tags
}


data "aws_ami" "img" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"
  name    = "${var.name}-sg"
  vpc_id  = var.vpc_id
  egress_rules = [
    "all-all"
  ]
}

resource "aws_instance" "host" {
  ami                    = data.aws_ami.img.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  user_data              = <<-EOF
#!/bin/bash
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo yum install -y socat
EOF
  vpc_security_group_ids = [module.sg.security_group_id]
  tags                   = merge(var.tags, tomap({ "Name" = var.name }))
}
