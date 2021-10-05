module "configuration" {
  source        = "github.com/kbst/terraform-kubestack//common/configuration?ref=v0.15.1-beta.1"
  configuration = var.configuration
  base_key      = var.configuration_base_key
}

locals {
  cfg = lookup(module.configuration.merged, terraform.workspace)

  name = local.cfg["name"]

  instance_types_lookup = local.cfg["instance_types"] == null ? "" : local.cfg["instance_types"]
  instance_types        = toset(split(",", local.instance_types_lookup))
  desired_capacity      = lookup(local.cfg, "desired_capacity")
  min_size              = lookup(local.cfg, "min_size")
  max_size              = lookup(local.cfg, "max_size")
  disk_size             = lookup(local.cfg, "disk_size", null)

  availability_zones_lookup = local.cfg["availability_zones"] == null ? "" : local.cfg["availability_zones"]
  availability_zones        = split(",", local.availability_zones_lookup)

  vpc_subnet_ids           = local.cfg["vpc_subnet_ids"] == null ? tolist(data.aws_eks_node_group.default.subnet_ids) : split(",", local.cfg["vpc_subnet_ids"])
  vpc_secondary_cidr       = lookup(local.cfg, "vpc_secondary_cidr", null)
  vpc_subnet_newbits       = lookup(local.cfg, "vpc_subnet_newbits", null)
  vpc_subnet_number_offset = local.cfg["vpc_subnet_number_offset"] == null ? 1 : local.cfg["vpc_subnet_number_offset"]
  vpc_subnet_map_public_ip = lookup(local.cfg, "vpc_subnet_map_public_ip", null)

  taints = local.cfg["taints"] == null ? toset([]) : local.cfg["taints"]
}
