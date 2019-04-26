locals {
  enable_zone_awareness = "${min(var.dedicated_master_count, var.instance_count) > 1 && length(var.subnet_ids) > 1 ? 1 : 0}"
}
