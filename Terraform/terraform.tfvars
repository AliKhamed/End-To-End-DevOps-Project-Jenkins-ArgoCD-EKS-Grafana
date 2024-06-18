vpc_name           = "ivolve-vpc"
vpc_cidr           = "10.0.0.0/16"
region             = "us-east-1"
ami                = "ami-04b70fa74e45c3917"
public_subnet1_cidr = "10.0.2.0/24"
public_subnet1_az   = "us-east-1a"
public_subnet2_cidr = "10.0.3.0/24"
public_subnet2_az   = "us-east-1b"
instance_type      = "t2.micro"
key_name           = "aws-key"
bucket-name        = "alikhames566-s3-bucket-terraform-fstat"
volume_size        = 20
sg = {
  ingress_count = [{ count = 3 }]
  ingress_rule = [{
    port     = 9000
    protocol = "tcp"
    cidr     = "0.0.0.0/0"
    },
    { port     = 8080
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    },
    { port     = 22
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
  }]
}

log_group_name                = "ivolve-log-group"
log_group_retention_in_days   = 14
log_stream_name               = "ivolve-log-stream"
alarm_name                    = "ivolve-alarm"
alarm_comparison_operator     = "GreaterThanOrEqualToThreshold"
alarm_evaluation_periods      = 1
alarm_metric_name             = "CPUUtilization"
alarm_namespace               = "AWS/EC2"
alarm_period                  = 300
alarm_statistic               = "Average"
alarm_threshold               = 50
sns_topic_name                = "ivolve-sns-topic"
sns_email                     = "alikhames566@gmail.com"
