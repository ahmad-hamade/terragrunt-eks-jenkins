variable "security_group" {
  description = "Name of the new security group to create"
  type = object({
    name                   = string
    description            = string
    vpc_id                 = string
    revoke_rules_on_delete = bool
  })
  default = null
}

variable "security_group_id" {
  description = "ID of the existing security group to update"
  type        = string
  default     = null
}

#--------------------------------------------------------------
# Ingress Variables
#--------------------------------------------------------------
variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = []
}

variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type = list(object({
    source_security_group_id = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = string
  }))
  default = []
}

#--------------------------------------------------------------
# Egress Variables
#--------------------------------------------------------------
variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type = list(object({
    cidr_blocks = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = []
}

variable "egress_with_self" {
  description = "List of egress rules to create where 'self' is defined"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
  }))
  default = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules to create where 'source_security_group_id' is used"
  type = list(object({
    source_security_group_id = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = string
  }))
  default = []
}

#--------------------------------------------------------------
# Other Variables
#--------------------------------------------------------------

variable "tags" {
  description = "An optional map of tags to add to aws resources."
  type        = map(string)
  default     = {}
}
