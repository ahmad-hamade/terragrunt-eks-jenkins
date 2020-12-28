# helm-installer

## Overview

A module used for installing helm charts in EKS Kubernetes cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 3.0 |
| helm | >= 2.0 |
| kubernetes | >= 1.13 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |
| helm | >= 2.0 |
| kubernetes | >= 1.13 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart | Chart name to be installed | `string` | n/a | yes |
| chart\_version | Specify the exact chart version to install. If this is not specified, the latest version is installed | `string` | `null` | no |
| cluster\_name | EKS cluster name | `string` | n/a | yes |
| create\_namespace | Create the namespace if it does not yet exist | `bool` | `false` | no |
| helm\_sets | Value block with custom STRING values to be merged with the values yaml. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| helm\_sets\_sensitive | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff. | <pre>list(object({<br>    path  = string<br>    value = string<br>  }))</pre> | `null` | no |
| helm\_values | Values in raw yaml to pass to helm. Values will be merged, in order | `string` | `null` | no |
| namespace | The namespace to install the release into. Defaults to `default` when the value is `null` | `string` | `null` | no |
| namespace\_config | Specify namespace labels and anotatations when the variable `create_namespace` is set to true | <pre>object({<br>    annotations = map(any)<br>    labels      = map(any)<br>  })</pre> | <pre>{<br>  "annotations": null,<br>  "labels": null<br>}</pre> | no |
| release\_name | Release name | `string` | n/a | yes |
| repository | Repository URL where to locate the requested chart | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| chart\_version | Chart version installed |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
