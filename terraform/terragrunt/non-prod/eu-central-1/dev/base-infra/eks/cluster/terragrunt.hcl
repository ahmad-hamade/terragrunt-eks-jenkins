locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.eks
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  cluster_name    = format("%s-eks", local.env.resource_name_prefix)
  cluster_version = "1.17"

  subnets = dependency.vpc.outputs.private_subnets
  vpc_id  = dependency.vpc.outputs.vpc_id

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_enabled_log_types     = ["api", "audit", "authenticator"]
  cluster_log_retention_in_days = 3

  create_fargate_pod_execution_role = false
  enable_irsa                       = true

  write_kubeconfig = false

  worker_groups_launch_template = [
    {
      name                 = "apps"
      instance_type        = "t2.small"
      asg_desired_capacity = 1
      asg_max_size         = 3
      asg_min_size         = 1
      subnets              = dependency.vpc.outputs.private_subnets
    },
    {
      name                    = "jenkins"
      override_instance_types = ["m5.large", "m5a.large", "m5d.large", "m5ad.large"]
      spot_instance_pools     = 4
      asg_max_size            = 5
      asg_min_size            = 0
      kubelet_extra_args      = "--kubelet-extra-args --register-with-taints=dedicated=jenkins:NoSchedule --node-labels=node.kubernetes.io/lifecycle=spot"
      subnets                 = dependency.vpc.outputs.private_subnets
    },
  ]

}
