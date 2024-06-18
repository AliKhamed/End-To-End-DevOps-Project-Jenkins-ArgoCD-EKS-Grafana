output "log_group_name" {
  value       = aws_cloudwatch_log_group.log_group.name
}

output "log_stream_name" {
  value       = aws_cloudwatch_log_stream.log_stream.name
}

output "alarm_name" {
  value       = aws_cloudwatch_metric_alarm.alarm.alarm_name
}

output "sns_topic_arn" {
  value       = aws_sns_topic.sns_topic.arn
}
