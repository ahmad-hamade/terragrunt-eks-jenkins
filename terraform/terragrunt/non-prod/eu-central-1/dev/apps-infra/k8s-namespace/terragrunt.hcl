locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = format("%s/../modules/k8s-namespace//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../base-infra/eks/config"]
}

dependency "cluster" {
  config_path = "../../base-infra/eks/cluster"
}

inputs = {
  cluster_name = dependency.cluster.outputs.cluster_id
  namespace    = local.env.environment_name
  namespace_config = {
    annotations = {
      # Uncomment the below annotation if you want to scale down Jenkins out of office hours
      # "downscaler/uptime" = "Mon-Fri 07:00-19:00 CET"
    }
    labels = {}
  }
}
