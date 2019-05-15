output "elasticsearch_endpoint" {
  description = "The url endpoint for the ElasticSearch cluster."
  value       = "${aws_elasticsearch_domain.this.endpoint}"
}

output "elasticsearch_arn" {
  description = "Amazon ARN of the ElasticSearch domain."
  value       = "${aws_elasticsearch_domain.this.arn}"
}

output "elasticsearch_domain_id" {
  description = "The unique ID of the ElasticSearch domain."
  value       = "${aws_elasticsearch_domain.this.domain_id}"
}

output "elasticsearch_domain_name" {
  description = "The name of the ElasticSearch domain."
  value       = "${aws_elasticsearch_domain.this.domain_name}"
}

output "kibana_endpoint" {
  description = "The domain endpoint for Kibana (without https scheme)."
  value       = "${aws_elasticsearch_domain.this.kibana_endpoint}"
}

output "iam_role_arn" {
  description = "Arn of the IAM role for logging"
  value       = "${aws_iam_role.logging_role.arn}"
}
