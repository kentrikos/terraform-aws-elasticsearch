# terraform-aws-elasticsearch

A terraform module to create a managed ElasticSearch cluster on AWS ElasticSearch Service.  

## Usage example

```hcl
module "my-elasticsearch" {

}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_cidrs | List of CIDR ranges to allow HTTPS access to the elasticsearch cluster | list | `<list>` | no |
| create_service_linked_role | Create an IAM Service linked role for ElasticSearch | string | `true` | no |
| dedicated_master_instance_count | Number of dedicated master instances in the elasticsearch cluster | string | `1` | no |
| domain_name | Name of the Elasticsearch cluster | string | - | yes |
| elasticsearch_version | Verion of Elasticsearch cluster | string | `6.4` | no |
| instance_count | Number of instances in the elasticsearch cluster | string | `1` | no |
| instance_type | Instance type of the elasticsearch cluster | string | `m4.large.elasticsearch` | no |
| region | AWS region name | string | - | yes |
| subnet_ids | List of subnet ids to host the Elasticsearch cluster | list | - | yes |
| tags | Map of tags to apply to resources | map | `<map>` | no |
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