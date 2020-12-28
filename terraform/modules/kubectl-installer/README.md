# kubectl-installer

## Overview

A module used for installing kubernetes resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| kubectl | >= 1.9.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| kubectl | >= 1.9.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | EKS Cluster name | `string` | n/a | yes |
| ignore\_fields | List of map fields to ignore when applying the manifest | `list(string)` | `[]` | no |
| yaml\_body | YAML to apply to kubernetes | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| manifests\_name | List of manifest resources installed in cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
