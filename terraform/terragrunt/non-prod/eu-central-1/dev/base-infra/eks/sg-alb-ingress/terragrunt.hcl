locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = format("%s/../modules/security-group//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "cluster" {
  config_path = "../cluster"
}

inputs = {
  security_group = {
    name                   = format("%s-alb-ingress-sg", dependency.cluster.outputs.cluster_id)
    description            = "EKS ALB ingress Security Group"
    vpc_id                 = dependency.vpc.outputs.vpc_id
    revoke_rules_on_delete = true
  }

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "For http to https redirection"
      cidr_blocks = local.env.whitelist_ingress_cidr
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow access from internet"
      cidr_blocks = local.env.whitelist_ingress_cidr
    }
  ]

  egress_with_source_security_group_id = [
    {
      from_port                = 30000
      to_port                  = 32767
      protocol                 = "tcp"
      description              = "EKS worker nodes"
      source_security_group_id = dependency.cluster.outputs.worker_security_group_id
    }
  ]
}
