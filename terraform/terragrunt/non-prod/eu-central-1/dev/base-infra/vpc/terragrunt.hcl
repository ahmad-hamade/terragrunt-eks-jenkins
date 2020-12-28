locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.vpc
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name = format("%s-vpc", local.env.environment_name)

  azs = formatlist("${local.region.aws_region_id}%s", local.region.aws_zones)

  cidr            = local.env.vpc_cidr_block
  private_subnets = local.env.private_subnets_cidr_block
  public_subnets  = local.env.public_subnets_cidr_block

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_dhcp_options      = true
  dhcp_options_domain_name = local.env.dhcp_options_domain_name

  manage_default_security_group = false

  # VPC endpoints
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  private_subnet_tags = merge(
    {
      "kubernetes.io/role/internal-elb"                                      = "1"
      format("kubernetes.io/cluster/%s-eks", local.env.resource_name_prefix) = "shared"
    }
  )
  public_subnet_tags = merge(
    {
      "kubernetes.io/role/elb"                                               = "1"
      format("kubernetes.io/cluster/%s-eks", local.env.resource_name_prefix) = "shared"
    }
  )
}
