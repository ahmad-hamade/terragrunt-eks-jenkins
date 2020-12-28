locals {
  global  = yamldecode(file("global.yaml"))
  account = try(yamldecode(file(find_in_parent_folders("account.yaml"))), null)
  region  = try(yamldecode(file(find_in_parent_folders("region.yaml"))), null)
  env     = try(yamldecode(file(find_in_parent_folders("env.yaml"))), null)

  run_in_automation = tobool(get_env("TF_IN_AUTOMATION", false))
  current_user      = local.run_in_automation ? "Automation" : try(get_aws_caller_identity_user_id(), get_env("USER", "NA"))

  providers   = try(read_terragrunt_config("providers.hcl"), null)
  tfplan_path = format("%s/%s", format("%s/../../tmp", get_parent_terragrunt_dir()), uuid())

  tfstate_s3_bucket      = format("%s-%s-terraform-state", local.account.aws_account_id, local.region.aws_region_id)
  tfstate_dynamodb_table = format("%s-%s-terraform-locks", local.account.aws_account_id, local.region.aws_region_id)
  tfstate_path           = format("%s/terraform.tfstate", path_relative_to_include())

  ignored_tags = get_terraform_command() != "plan" ? {
    UpdatedBy = local.current_user
  } : {}

  standard_tags = merge(
    local.ignored_tags,
    {
      Product     = local.global.product_name
      Contact     = local.global.contact
      Source      = local.global.orchestration
      Environment = local.env.environment_name
      Component   = path_relative_to_include()
    }
  )
}

# Ignore running terragrunt from root hcl
skip = true

terraform_version_constraint  = format("= %s", file("../.terraform-version"))
terragrunt_version_constraint = format("= %s", file("../.terragrunt-version"))

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = templatefile("providers.tpl", {
    # AWS Provider
    aws_version      = try(local.providers.locals.aws_provider.version, "~> 3.0")
    aws_region       = try(local.providers.locals.aws_provider.region, local.region.aws_region_id)
    aws_account_id   = local.account.aws_account_id
    ignore_updatedby = get_terraform_command() == "plan"
  })
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt                        = true
    bucket                         = local.tfstate_s3_bucket
    key                            = local.tfstate_path
    region                         = local.region.aws_region_id
    dynamodb_table                 = local.tfstate_dynamodb_table
    enable_lock_table_ssencryption = true
    skip_bucket_enforced_tls       = false
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  extra_arguments "tfplan_out" {
    commands = ["plan"]
    arguments = local.run_in_automation ? [
      path_relative_to_include(),
      local.tfplan_path,
      "-lock=false",
      "-no-color",
      "-detailed-exitcode",
      "-compact-warnings"
    ] : []
  }

  after_hook "cleanup_tfstate" {
    commands = ["destroy"]
    execute = [
      format("%s/../../scripts/cleanup-tfstate.sh", get_parent_terragrunt_dir()),
      local.region.aws_region_id,
      local.tfstate_s3_bucket,
      local.tfstate_dynamodb_table,
      local.tfstate_path,
      get_terragrunt_dir(),
    ]
    run_on_error = false
  }
}

inputs = {
  tags = local.standard_tags
}

retryable_errors = [
  // Default ones that need to be updated regularly from the following location:
  // https://github.com/gruntwork-io/terragrunt/blob/master/options/auto_retry_options.go#L10
  // You can remove the default errors once this issue is resolved https://github.com/gruntwork-io/terragrunt/issues/1383
  "(?s).*Failed to load state.*tcp.*timeout.*",
  "(?s).*Failed to load backend.*TLS handshake timeout.*",
  "(?s).*Creating metric alarm failed.*request to update this alarm is in progress.*",
  "(?s).*Error installing provider.*TLS handshake timeout.*",
  "(?s).*Error configuring the backend.*TLS handshake timeout.*",
  "(?s).*Error installing provider.*tcp.*timeout.*",
  "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
  "NoSuchBucket: The specified bucket does not exist",
  "(?s).*Error creating SSM parameter: TooManyUpdates:.*",
  "(?s).*app.terraform.io.*: 429 Too Many Requests.*",
  "(?s).*ssh_exchange_identification.*Connection closed by remote host.*",

  // Custom error messages
  "(?s).*Error: No valid credential sources found for AWS Provider.*",
  "(?s).*ssh: connect to host github.com port 22: Connection refused.*",
  "(?s).*Failed to query available provider packages.*",
]
