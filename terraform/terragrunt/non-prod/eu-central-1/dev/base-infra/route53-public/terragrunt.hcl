locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.route53_zone
}

include {
  path = find_in_parent_folders()
}

inputs = {
  zones = {
    "${local.env.domain_name_public}" = {
      comment = local.env.environment_name
    }
  }
}
