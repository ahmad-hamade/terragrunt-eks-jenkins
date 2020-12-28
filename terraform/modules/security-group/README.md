# security-group

## Overview

A module used for creating or modifying AWS Security Group.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| egress\_with\_cidr\_blocks | List of egress rules to create where 'cidr\_blocks' is used | <pre>list(object({<br>    cidr_blocks = list(string)<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    description = string<br>  }))</pre> | `[]` | no |
| egress\_with\_self | List of egress rules to create where 'self' is defined | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    description = string<br>  }))</pre> | `[]` | no |
| egress\_with\_source\_security\_group\_id | List of egress rules to create where 'source\_security\_group\_id' is used | <pre>list(object({<br>    source_security_group_id = string<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| ingress\_with\_cidr\_blocks | List of ingress rules to create where 'cidr\_blocks' is used | <pre>list(object({<br>    cidr_blocks = list(string)<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    description = string<br>  }))</pre> | `[]` | no |
| ingress\_with\_self | List of ingress rules to create where 'self' is defined | <pre>list(object({<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    description = string<br>  }))</pre> | `[]` | no |
| ingress\_with\_source\_security\_group\_id | List of ingress rules to create where 'source\_security\_group\_id' is used | <pre>list(object({<br>    source_security_group_id = string<br>    from_port                = number<br>    to_port                  = number<br>    protocol                 = string<br>    description              = string<br>  }))</pre> | `[]` | no |
| security\_group | Name of the new security group to create | <pre>object({<br>    name                   = string<br>    description            = string<br>    vpc_id                 = string<br>    revoke_rules_on_delete = bool<br>  })</pre> | `null` | no |
| security\_group\_id | ID of the existing security group to update | `string` | `null` | no |
| tags | An optional map of tags to add to aws resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id | The ID of the security group |
| security\_group\_name | The name of the security group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
