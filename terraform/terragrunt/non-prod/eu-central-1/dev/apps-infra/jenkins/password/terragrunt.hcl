locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = format("%s/../modules/random-generator//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

inputs = {

}
