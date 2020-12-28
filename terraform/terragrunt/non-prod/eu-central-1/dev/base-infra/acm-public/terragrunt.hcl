locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = local.modules.acm_public
}

include {
  path = find_in_parent_folders()
}

dependency "route53_public" {
  config_path = "../route53-public"
}

inputs = {
  domain_name = keys(dependency.route53_public.outputs.this_route53_zone_zone_id)[0]
  zone_id     = values(dependency.route53_public.outputs.this_route53_zone_zone_id)[0]

  subject_alternative_names = [
    format("*.%s", keys(dependency.route53_public.outputs.this_route53_zone_zone_id)[0])
  ]

  # You need to ensure you configure your domain with the correct NS that is pointing to Route53
  # The ACM validation will fail If you failed to complete the NS setup
  validate_certificate = true
}
