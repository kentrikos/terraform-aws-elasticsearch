variable "region" {
  description = "AWS region name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "elasticsearch_subnet_ids" {
  description = "List of subnet ids to host the Elasticsearch cluster"
  type        = list(string)
}

variable "elasticsearch_domain_name" {
  description = "Name of the Elasticsearch cluster"
}

variable "elasticsearch_version" {
  description = "Verion of Elasticsearch cluster"
  default     = "6.5"
}

variable "elasticsearch_volume_size" {
  description = "The size of the EBS volumes attached in GB (size per instance)"
  default     = 10
}

variable "elasticsearch_instance_type" {
  description = "Instance type of the elasticsearch cluster"
  default     = "r5.large.elasticsearch"
}

variable "elasticsearch_instance_count" {
  description = "Number of instances in the elasticsearch cluster"
  default     = 1
}

variable "elasticsearch_dedicated_master_count" {
  description = "Number of dedicated master instances in the elasticsearch cluster"
  default     = 3
}

variable "elasticsearch_dedicated_master_type" {
  description = "Instance type of the elasticsearch dedicated masters"
  default     = "r5.large.elasticsearch"
}

variable "elasticsearch_allowed_cidrs" {
  description = "List of CIDR ranges to allow HTTPS access to the elasticsearch cluster"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "elasticsearch_enable_zone_awareness" {
  description = "Enable multi-avaliability zone deployment of the Elasticsearch nodes. (If enabled, the number of subnets must be a multiple of the instance_count)"
  default     = false
}

variable "trusted_roles_arns" {
  description = "List of trusted role arns allowed to assume role allowed for logging into Elasticsearch"
  type        = list(string)
  default     = []
}

variable "enable_fluentd" {
  description = "Enable/Deploy fluentd into the cluster and ship logs to ES"
  default     = true
}

variable "cluster_context" {
  description = "The kubernetes context to use for deployment of fluentd"
  default     = ""
}

variable "tiller_service_account" {
  description = "Tiller service account name used for helm"
  default     = "tiller"
}

variable "fluentd_namespace" {
  description = "The kubernetes namespace to use for the fluentd deployment"
  default     = "logging"
}

variable "fluentd_release_name" {
  description = "Name for the fluentd deployment"
  default     = "fluentd-elasticsearch"
}

variable "fluentd_image_repository" {
  description = "The URI of the repository containing the fluentd image"
  default     = ""
}

variable "fluentd_image_tag" {
  description = "The tag of the image to use for fluentd"
  default     = "latest"
}

variable "elasticsearch_logstash_prefix" {
  description = "Prefix of logstash indexes created in ElasticSearch"
  default     = "logstash"
}

