locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = format("%s/../modules/kubectl-installer//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../jenkins/helm-chart"]
}

dependency "cluster" {
  config_path = "../../base-infra/eks/cluster"
}

dependency "k8s_namespace" {
  config_path = "../k8s-namespace"
}

inputs = {
  cluster_name = dependency.cluster.outputs.cluster_id
  yaml_body = templatefile("rbac.yaml", {
    namespace = dependency.k8s_namespace.outputs.namespace
  })
}
