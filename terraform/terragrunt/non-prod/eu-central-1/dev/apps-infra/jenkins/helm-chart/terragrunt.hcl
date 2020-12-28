locals {
  global  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account = yamldecode(file(find_in_parent_folders("account.yaml")))
  region  = yamldecode(file(find_in_parent_folders("region.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env.yaml")))
  modules = yamldecode(file(find_in_parent_folders("modules.yaml")))
}

terraform {
  source = format("%s/../modules/helm-installer//.", get_parent_terragrunt_dir())
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../../base-infra/eks/config"]
}

dependency "password" {
  config_path = "../password"
}

dependency "eks_cluster" {
  config_path = "../../../base-infra/eks/cluster"
}

dependency "sg_alb_ingress" {
  config_path = "../../../base-infra/eks/sg-alb-ingress"
}

dependency "route53_public" {
  config_path = "../../../base-infra/route53-public"
}

dependency "acm_public" {
  config_path = "../../../base-infra/acm-public"
}

dependency "eks_iam" {
  config_path = "../eks-iam"
}

dependency "s3_backup" {
  config_path = "../s3-backup"
}

dependency "logging_bucket" {
  config_path = "../../../base-infra/logging/logging-bucket"
}

dependency "ecr_backend" {
  config_path = "../ecr-agents/backend"
}

inputs = {
  cluster_name  = dependency.eks_cluster.outputs.cluster_id
  release_name  = "jenkins"
  repository    = "https://charts.jenkins.io"
  chart         = "jenkins"
  chart_version = "2.19.0"

  create_namespace = true
  namespace        = "jenkins"
  namespace_config = {
    annotations = {
      # Uncomment the below annotation if you want to scale down Jenkins out of office hours
      # "downscaler/uptime" = "Mon-Fri 07:00-19:00 CET"
    }
    labels = {}
  }

  helm_values = templatefile("values.yaml",
    {
      // Jenkins Config
      admin_username    = "admin"
      admin_password    = dependency.password.outputs.result
      iam_role_arn      = dependency.eks_iam.outputs.iam_role_arn
      alb_ingress_sg    = dependency.sg_alb_ingress.outputs.security_group_id
      acm_arn           = dependency.acm_public.outputs.this_acm_certificate_arn
      hostname          = format("jenkins.%s", keys(dependency.route53_public.outputs.this_route53_zone_zone_id)[0])
      image_tag         = "2.263.1-lts-alpine"
      s3_backup_name    = dependency.s3_backup.outputs.this_s3_bucket_id
      s3_logging_bucket = dependency.logging_bucket.outputs.this_s3_bucket_id

      // ECR Agents
      ecr_backend_url = dependency.ecr_backend.outputs.repository_url

      // Env Vars
      aws_region       = local.region.aws_region_id
      aws_account_id   = local.account.aws_account_id
      environment_name = local.env.environment_name
      domain_name      = keys(dependency.route53_public.outputs.this_route53_zone_zone_id)[0]

      # // Jobs
      job_tomcat_app = indent(14, file("jobs/tomcat-app.groovy"))
    }
  )
}
