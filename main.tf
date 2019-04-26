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
    ebs_enabled = "${var.volume_size > 0 ? true : false }"
    volume_size = "${var.volume_size}"
  }

  cluster_config {
    instance_count           = "${var.instance_count}"
    instance_type            = "${var.instance_type}"
    dedicated_master_enabled = "${var.dedicated_master_count > 0 ? 1 : 0}"
    dedicated_master_count   = "${var.dedicated_master_count}"
    dedicated_master_type    = "${var.dedicated_master_type}"
    zone_awareness_enabled   = "${var.enable_zone_awareness}"
  }

  vpc_options {
    # subnet_ids         = ["${slice(var.subnet_ids, 0, (local.enable_zone_awareness == 0 ? 1 : length(var.subnet_ids) - (length(var.subnet_ids) % 2) ))}"]
    subnet_ids         = ["${var.subnet_ids}"]
    security_group_ids = ["${aws_security_group.elasticsearch_https.id}"]
  }

  access_policies = "${data.aws_iam_policy_document.elasticsearch_access.json}"

  tags = "${var.tags}"
}

resource "aws_security_group" "elasticsearch_https" {
  name   = "elasticsearch-logging-${var.domain_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["${var.elasticsearch_allowed_cidrs}"]
  }
}

//logging iam policies and roles
data "aws_iam_policy_document" "logging_policy" {
  statement {
    sid    = "ElasticSearchLimitedAccess"
    effect = "Allow"

    actions = [
      "es:ESHttpPost",
      "es:ESHttpGet",
      "es:ESHttpPut",
    ]

    resources = ["${aws_elasticsearch_domain.this.arn}"]
  }
}

data "aws_iam_policy_document" "logging_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = "${var.trusted_roles_arns}"
    }
  }
}

resource "aws_iam_policy" "logging_policy" {
  name   = "elasticsearch-logging-${var.domain_name}"
  policy = "${data.aws_iam_policy_document.logging_policy.json}"
}

resource "aws_iam_role" "logging_role" {
  name               = "elasticsearch-logging-${var.domain_name}"
  assume_role_policy = "${data.aws_iam_policy_document.logging_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "logging_attachments" {
  role       = "${aws_iam_role.logging_role.id}"
  policy_arn = "${aws_iam_policy.logging_policy.arn}"
}

//fluentd deployment
data "template_file" "helm_fluentd_values" {
  template = "${file("${path.module}/templates/helm_fluentd_values.yaml.tpl")}"

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.this.endpoint}"
    image_url              = "${var.fluentd_image_repository}"
    image_tag              = "${var.fluentd_image_tag}"
    region                 = "${var.region}"
    logstash_prefix        = "${var.logstash_prefix}"
  }
}

resource "helm_release" "fluentd" {
  count     = "${var.enable_fluentd && var.fluentd_image_repository != "" ? 1 : 0}"
  name      = "${var.fluentd_release_name}"
  chart     = "stable/fluentd-elasticsearch"
  namespace = "${var.fluentd_namespace}"

  values     = ["${data.template_file.helm_fluentd_values.rendered}"]
  depends_on = ["aws_elasticsearch_domain.this"]
}
