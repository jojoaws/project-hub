output "vpc_id" {

  value = module.networking.vpc_id

}

output "alb_dns_name" {

  value = aws_lb.main.dns_name

}

output "cloudfront_domain_name" {

  value = aws_cloudfront_distribution.frontend.domain_name

}

output "ecr_repository_url" {

  value = aws_ecr_repository.api.repository_url

}

output "rds_endpoint" {

  value = aws_db_instance.postgres.endpoint

}

output "uploads_bucket_name" {

  value = aws_s3_bucket.uploads.bucket

}

output "sns_topic_arn" {

  value = aws_sns_topic.notifications.arn

}

output "ops_alerts_topic_arn" {

  value = aws_sns_topic.ops_alerts.arn

}

output "ecs_cluster_name" {

  value = aws_ecs_cluster.main.name

}

output "ecs_service_name" {

  value = aws_ecs_service.api.name

}

output "ecs_task_family" {

  value = aws_ecs_task_definition.api.family

}
