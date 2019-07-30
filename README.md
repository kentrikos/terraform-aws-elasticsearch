# terraform-aws-logging

A terraform module to create a logging infrastructure based around AWS ElasticSearch Service, Kubernetes and Fluentd.  

# Notes

Terraform version  `>= 0.12`

## Usage example

```hcl
module "my-logging" {
    source = "github.com/kentrikos/terraform-aws-logging"
    region = "us-east-1"
    vpc_id = "vpc-123456789"
    subnet_ids                  = ["subnet-123456", "subnet-654321"]
    domain_name                 = "my-logging"
    elasticsearch_allowed_cidrs = ["10.0.0.0/8"]
    instance_count              = 2
    instance_type               = "t2.medium.elasticsearch"

    enable_fluentd           = true
    cluster_context          = "my-cluster-context"
    fluentd_image_repository = "1234567890.dkr.ecr.us-east-1.amazonaws.com/my-fluentd-elasticsearch"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `cluster_context` | The kubernetes context to use for deployment of fluentd | n/a | n/a |  yes |
| `elasticsearch_allowed_cidrs` | List of CIDR ranges to allow HTTPS access to the elasticsearch cluster | list(string) | n/a |  yes |
| `elasticsearch_dedicated_master_count` | Number of dedicated master instances in the elasticsearch cluster | n/a | `3` |  no |
| `elasticsearch_dedicated_master_type` | Instance type of the elasticsearch dedicated masters | n/a | `"r5.large.elasticsearch"` |  no |
| `elasticsearch_domain_name` | Name of the Elasticsearch cluster | n/a | n/a |  yes |
| `elasticsearch_enable_zone_awareness` | Enable multi-avaliability zone deployment of the Elasticsearch nodes. (If enabled, the number of subnets must be a multiple of the instance_count) | Boolean | n/a |  no |
| `elasticsearch_instance_count` | Number of instances in the elasticsearch cluster | n/a | `1` |  no |
| `elasticsearch_instance_type` | Instance type of the elasticsearch cluster | n/a | `"r5.large.elasticsearch"` |  no |
| `elasticsearch_logstash_prefix` | Prefix of logstash indexes created in ElasticSearch | n/a | `"logstash"` |  no |
| `elasticsearch_subnet_ids` | List of subnet ids to host the Elasticsearch cluster | list(string) | n/a |  yes |
| `elasticsearch_version` | Verion of Elasticsearch cluster | n/a | `"6.5"` |  no |
| `elasticsearch_volume_size` | The size of the EBS volumes attached in GB (size per instance) | n/a | `10` |  no |
| `enable_fluentd` | Enable/Deploy fluentd into the cluster and ship logs to ES | n/a | `true` |  no |
| `fluentd_image_repository` | The URI of the repository containing the fluentd image | n/a | n/a |  yes |
| `fluentd_image_tag` | The tag of the image to use for fluentd | n/a | `"latest"` |  no |
| `fluentd_namespace` | The kubernetes namespace to use for the fluentd deployment | n/a | `"logging"` |  no |
| `fluentd_release_name` | Name for the fluentd deployment | n/a | `"fluentd-elasticsearch"` |  no |
| `region` | AWS region name | n/a | n/a |  yes |
| `tags` | Map of tags to apply to resources | map(string) | n/a |  no |
| `tiller_service_account` | Tiller service account name used for helm | n/a | `"tiller"` |  no |
| `trusted_roles_arns` | List of trusted role arns allowed to assume role allowed for logging into Elasticsearch | list(string) | n/a |  no |
| `vpc_id` | VPC ID | n/a | n/a |  yes |

## Outputs

| Name | Description |
|------|-------------|
| `elasticsearch_arn` | Amazon ARN of the ElasticSearch domain. |
| `elasticsearch_domain_id` | The unique ID of the ElasticSearch domain. |
| `elasticsearch_domain_name` | The name of the ElasticSearch domain. |
| `elasticsearch_endpoint` | The url endpoint for the ElasticSearch cluster. |
| `iam_role_arn` | Arn of the IAM role for logging |
| `kibana_endpoint` | The domain endpoint for Kibana (without https scheme). |
