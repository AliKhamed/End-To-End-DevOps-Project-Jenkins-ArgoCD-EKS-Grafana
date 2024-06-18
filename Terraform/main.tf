provider "aws" {
  region  = var.region
  profile = "default"
}
module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet1_cidr = var.public_subnet1_cidr
  public_subnet1_az   = var.public_subnet1_az
  public_subnet2_cidr = var.public_subnet2_cidr
  public_subnet2_az   = var.public_subnet2_az
  vpc_name           = var.vpc_name
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = module.network.subnet1_id
  vpc_id        = module.network.vpc_id
  sg            = var.sg
  key_name      = var.key_name
  volume_size   = var.volume_size
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  log_group_name                = var.log_group_name
  log_group_retention_in_days   = var.log_group_retention_in_days
  log_stream_name               = var.log_stream_name
  alarm_name                    = var.alarm_name
  alarm_comparison_operator     = var.alarm_comparison_operator
  alarm_evaluation_periods      = var.alarm_evaluation_periods
  alarm_metric_name             = var.alarm_metric_name
  alarm_namespace               = var.alarm_namespace
  alarm_period                  = var.alarm_period
  alarm_statistic               = var.alarm_statistic
  alarm_threshold               = var.alarm_threshold
  instance_id                   = module.ec2.ec2_id
  sns_topic_name                = var.sns_topic_name
  sns_email                     = var.sns_email
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "ivolve_eks_cluster"
  subnet_ids         = [module.network.subnet1_id, module.network.subnet2_id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  instance_type      = "t3.medium"
  ssh_key_name       = var.key_name
}

resource "local_file" "private_key" {
  content    = tls_private_key.myprivatekey.private_key_pem
  filename   = "../Ansible/private_key.pem"
  depends_on = [module.ec2]
}

resource "null_resource" "set_permissions" {
  provisioner "local-exec" {
    command = "chmod 400 ../Ansible/private_key.pem"
  }

  depends_on = [local_file.private_key]
}