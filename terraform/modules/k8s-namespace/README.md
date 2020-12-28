# k8s-namespace

## Overview

Module used to create a Kubernetes namespace. And define CPU and Memory settings.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name | Name of the EKS cluster | `string` | n/a | yes |
| cpu\_limit | Container CPU Limit in a namespace | `string` | `"800m"` | no |
| cpu\_request | Container CPU Request in a namespace | `string` | `"400m"` | no |
| memory\_limit | Container Memory Limit in a namespace | `string` | `"1Gi"` | no |
| memory\_request | Container Memory Request in a namespace | `string` | `"500M"` | no |
| namespace | K8S namespace name | `string` | `null` | no |
| namespace\_config | Specify namespace labels and anotations | <pre>object({<br>    annotations = map(any)<br>    labels      = map(any)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The name of namespace created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
