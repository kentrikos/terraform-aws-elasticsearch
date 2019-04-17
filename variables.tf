variable "region" {
  description = "AWS region name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  description = "List of subnet ids to host the Elasticsearch cluster"
  type        = "list"
}

variable "domain_name" {
  description = "Name of the Elasticsearch cluster"
}

variable "elasticsearch_version" {
  description = "Verion of Elasticsearch cluster"
  default     = "6.4"
}

variable "volume_size" {
  description = "The size of the EBS volumes attached in GB (size per instance)"
  default     = 10
}

variable "instance_type" {
  description = "Instance type of the elasticsearch cluster"
  default     = "m4.large.elasticsearch"
}

variable "instance_count" {
  description = "Number of instances in the elasticsearch cluster"
  default     = 1
}

variable "dedicated_master_instance_count" {
  description = "Number of dedicated master instances in the elasticsearch cluster"
  default     = 1
}

variable "allowed_cidrs" {
  description = "List of CIDR ranges to allow HTTPS access to the elasticsearch cluster"
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = "map"
  default     = {}
}
