variable "region" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "public_subnet1_cidr" {
  type = string
}
variable "public_subnet1_az" {
  type = string
}
variable "public_subnet2_cidr" {
  type = string
}
variable "public_subnet2_az" {
  type = string
}
variable "ami" {
  type = string
}
variable "sg" {
  type = map(any)
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "volume_size" {
  type = number
}
variable "bucket-name" {
  type = string
}
variable "log_group_name" {
  type        = string
}

variable "log_group_retention_in_days" {
  type        = number
}

variable "log_stream_name" {
  type        = string
}

variable "alarm_name" {
  type        = string
}

variable "alarm_comparison_operator" {
  type        = string
}

variable "alarm_evaluation_periods" {
  type        = number
}

variable "alarm_metric_name" {
  description = "The name for the alarm's associated metric"
  type        = string
}

variable "alarm_namespace" {
  type        = string
}

variable "alarm_period" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
}

variable "alarm_statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  type        = string
}

variable "alarm_threshold" {
  type        = number
}

variable "sns_topic_name" {
  type        = string
}

variable "sns_email" {
  type        = string
}
