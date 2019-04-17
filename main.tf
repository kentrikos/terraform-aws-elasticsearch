data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "elasticsearch_access" {
  statement {
    sid       = "ElasticSearchAccess"
    actions   = ["es:*"]
    effect    = "Allow"
    resources = ["arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.domain_name}/*"]

    principals = {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.volume_size}"
  }

  cluster_config {
    instance_count           = "${var.instance_count}"
    instance_type            = "${var.instance_type}"
    dedicated_master_enabled = "${var.dedicated_master_instance_count > 0 ? 1 : 0}"
    dedicated_master_count   = "${var.dedicated_master_instance_count}"
    zone_awareness_enabled   = "${local.enable_zone_awareness}"
  }

  vpc_options {
    subnet_ids         = ["${slice(var.subnet_ids, 0, (local.enable_zone_awareness == 0 ? 1 : length(var.subnet_ids) - (length(var.subnet_ids) % 2) ))}"]
    security_group_ids = ["${aws_security_group.elasticsearch.id}"]
  }

  access_policies = "${data.aws_iam_policy_document.elasticsearch_access.json}"

  tags = "${var.tags}"
}

resource "aws_security_group" "elasticsearch_https" {
  name   = "elasticsearch-${var.domain_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["${var.allowed_cidrs}"]
  }
}
