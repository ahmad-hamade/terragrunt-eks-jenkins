locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.ecr
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name         = format("%s/tomcat-app", local.env.resource_name_prefix)
  scan_on_push = true
}
