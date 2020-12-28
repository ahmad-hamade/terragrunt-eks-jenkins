locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))

  bucket_name = format("%s-%s-jenkins-backup", local.account.aws_account_id, local.env.environment_name)
}

terraform {
  source = local.modules.s3_bucket
}

include {
  path = find_in_parent_folders()
}

dependency "logging_bucket" {
  config_path = "../../../base-infra/logging/logging-bucket"
}

inputs = {
  bucket        = format("%s-%s-jenkins-backup", local.account.aws_account_id, local.env.environment_name)
  force_destroy = true

  logging = {
    target_bucket = dependency.logging_bucket.outputs.this_s3_bucket_id
    target_prefix = format("s3-logs/%s/", local.bucket_name)
  }
}
