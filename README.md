# terraform-aws-logging

A terraform module to create a logging infrastructure based around AWS ElasticSearch Service, Kubernetes and Fluentd.  

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
| cluster_context | The kubernetes context to use for deployment of fluentd | string | `` | no |
| dedicated_master_count | Number of dedicated master instances in the elasticsearch cluster | string | `3` | no |
| dedicated_master_type | Instance type of the elasticsearch dedicated masters | string | `r5.large.elasticsearch` | no |
| domain_name | Name of the Elasticsearch cluster | string | - | yes |
| elasticsearch_allowed_cidrs | List of CIDR ranges to allow HTTPS access to the elasticsearch cluster | list | `<list>` | no |
| elasticsearch_version | Verion of Elasticsearch cluster | string | `6.5` | no |
| enable_fluentd | Enable/Deploy fluentd into the cluster and ship logs to ES | string | `true` | no |
| enable_zone_awareness | Enable multi-avaliability zone deployment of the Elasticsearch nodes. (If enabled, the number of subnets must be a multiple of the instance_count) | string | `true` | no |
| fluentd_image_repository | The URI of the repository containing the fluentd image | string | `` | no |
| fluentd_image_tag | The tag of the image to use for fluentd | string | `latest` | no |
| fluentd_namespace | The kubernetes namespace to use for the fluentd deployment | string | `logging` | no |
| fluentd_release_name | Name for the fluentd deployment | string | `fluentd-elasticsearch` | no |
| instance_count | Number of instances in the elasticsearch cluster | string | `1` | no |
| instance_type | Instance type of the elasticsearch cluster | string | `r5.large.elasticsearch` | no |
| logstash_prefix | Prefix of logstash indexes created in ElasticSearch | string | `logstash` | no |
| region | AWS region name | string | - | yes |
| subnet_ids | List of subnet ids to host the Elasticsearch cluster | list | - | yes |
| tags | Map of tags to apply to resources | map | `<map>` | no |
| tiller_service_account | Tiller service account name used for helm | string | `tiller` | no |
| trusted_roles_arns | List of trusted role arns allowed to assume role allowed for logging into Elasticsearch | list | `<list>` | no |
| volume_size | The size of the EBS volumes attached in GB (size per instance) | string | `10` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon ARN of the ElasticSearch domain. |
| domain_id | The unique ID of the ElasticSearch domain. |
| domain_name | The name of the ElasticSearch domain. |
| endpoint | The url endpoint for the ElasticSearch cluster. |
| kibana_endpoint | The domain endpoint for Kibana (without https scheme). |