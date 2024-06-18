variable "log_group_name" {
  type        = string
}

variable "log_group_retention_in_days" {
  type        = number
  default     = 7
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
  type        = string
}

variable "alarm_namespace" {
  type        = string
}

variable "alarm_period" {
  type        = number
}

variable "alarm_statistic" {
  type        = string
}

variable "alarm_threshold" {
  type        = number
}

variable "alarm_description" {
  type        = string
  default     = ""
}

variable "instance_id" {
  type        = string
}

variable "sns_topic_name" {
  type        = string
}

variable "sns_email" {
  description = "The email address for SNS notifications"
  type        = string
}
