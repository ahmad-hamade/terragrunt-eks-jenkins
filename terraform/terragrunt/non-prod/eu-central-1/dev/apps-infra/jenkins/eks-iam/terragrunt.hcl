locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.eks_iam_role
}

include {
  path = find_in_parent_folders()
}

dependency "eks_cluster" {
  config_path = "../../../base-infra/eks/cluster"
}

dependency "s3_backup" {
  config_path = "../s3-backup"
}

inputs = {
  cluster_name     = dependency.eks_cluster.outputs.cluster_id
  role_name        = "jenkins-role"
  service_accounts = ["jenkins/jenkins-master", "jenkins/jenkins-agent", "jenkins/jenkins-backup"]

  policies = [templatefile("policy.json",
    {
      region        = local.region.aws_region_id
      account_id    = local.account.aws_account_id
      ecr_path      = local.env.environment_name
      s3_backup_arn = dependency.s3_backup.outputs.this_s3_bucket_arn
    }
  )]
}
