locals {
  sg_id = concat(
    aws_security_group.sg.*.id,
    data.aws_security_group.selected.*.id,
    [""],
  )[0]
}

resource "aws_security_group" "sg" {
  count = (var.security_group_id == null || var.security_group_id == "") && var.security_group != null ? 1 : 0

  name_prefix            = var.security_group.name
  description            = var.security_group.description
  vpc_id                 = var.security_group.vpc_id
  revoke_rules_on_delete = var.security_group.revoke_rules_on_delete

  tags = var.tags
}

data "aws_security_group" "selected" {
  count = var.security_group == null && var.security_group_id != null && var.security_group_id != "" ? 1 : 0
  id    = var.security_group_id
}

#--------------------------------------------------------------
# Ingress Rules
#--------------------------------------------------------------
resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count             = length(var.ingress_with_cidr_blocks)
  security_group_id = local.sg_id
  type              = "ingress"
  cidr_blocks       = var.ingress_with_cidr_blocks[count.index].cidr_blocks
  description       = var.ingress_with_cidr_blocks[count.index].description
  from_port         = var.ingress_with_cidr_blocks[count.index].from_port
  to_port           = var.ingress_with_cidr_blocks[count.index].to_port
  protocol          = var.ingress_with_cidr_blocks[count.index].protocol
}

resource "aws_security_group_rule" "ingress_with_self" {
  count             = length(var.ingress_with_self)
  security_group_id = local.sg_id
  type              = "ingress"
  self              = true
  description       = var.ingress_with_self[count.index].description
  from_port         = var.ingress_with_self[count.index].from_port
  to_port           = var.ingress_with_self[count.index].to_port
  protocol          = var.ingress_with_self[count.index].protocol
}

resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
  count                    = length(var.ingress_with_source_security_group_id)
  security_group_id        = local.sg_id
  type                     = "ingress"
  source_security_group_id = var.ingress_with_source_security_group_id[count.index].source_security_group_id
  description              = var.ingress_with_source_security_group_id[count.index].description
  from_port                = var.ingress_with_source_security_group_id[count.index].from_port
  to_port                  = var.ingress_with_source_security_group_id[count.index].to_port
  protocol                 = var.ingress_with_source_security_group_id[count.index].protocol
}

#--------------------------------------------------------------
# Egress Rules
#--------------------------------------------------------------
resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count             = length(var.egress_with_cidr_blocks)
  security_group_id = local.sg_id
  type              = "egress"
  cidr_blocks       = var.egress_with_cidr_blocks[count.index].cidr_blocks
  description       = var.egress_with_cidr_blocks[count.index].description
  from_port         = var.egress_with_cidr_blocks[count.index].from_port
  to_port           = var.egress_with_cidr_blocks[count.index].to_port
  protocol          = var.egress_with_cidr_blocks[count.index].protocol
}

resource "aws_security_group_rule" "egress_with_self" {
  count             = length(var.egress_with_self)
  security_group_id = local.sg_id
  type              = "egress"
  self              = true
  description       = var.egress_with_self[count.index].description
  from_port         = var.egress_with_self[count.index].from_port
  to_port           = var.egress_with_self[count.index].to_port
  protocol          = var.egress_with_self[count.index].protocol
}

resource "aws_security_group_rule" "egress_with_source_security_group_id" {
  count                    = length(var.egress_with_source_security_group_id)
  security_group_id        = local.sg_id
  type                     = "egress"
  source_security_group_id = var.egress_with_source_security_group_id[count.index].source_security_group_id
  description              = var.egress_with_source_security_group_id[count.index].description
  from_port                = var.egress_with_source_security_group_id[count.index].from_port
  to_port                  = var.egress_with_source_security_group_id[count.index].to_port
  protocol                 = var.egress_with_source_security_group_id[count.index].protocol
}
