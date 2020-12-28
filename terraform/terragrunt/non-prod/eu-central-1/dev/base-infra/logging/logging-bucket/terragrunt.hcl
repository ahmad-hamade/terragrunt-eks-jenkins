locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.s3_bucket
}

include {
  path = find_in_parent_folders()
}

inputs = {
  bucket        = format("%s-logging-bucket", local.env.s3_resource_name_prefix)
  acl           = "log-delivery-write"
  force_destroy = true

  attach_elb_log_delivery_policy = true

  attach_public_policy    = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
