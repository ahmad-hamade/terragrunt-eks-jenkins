locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = format("%s/../modules/security-group//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

dependency "cluster" {
  config_path = "../cluster"
}

dependency "sg_alb_ingress" {
  config_path = "../sg-alb-ingress"
}

inputs = {
  security_group_id = dependency.cluster.outputs.worker_security_group_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 30000
      to_port                  = 32767
      protocol                 = "tcp"
      description              = "EKS ALB ingress"
      source_security_group_id = dependency.sg_alb_ingress.outputs.security_group_id
    }
  ]
}
