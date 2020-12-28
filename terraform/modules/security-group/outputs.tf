output "security_group_id" {
  description = "The ID of the security group"
  value       = local.sg_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = concat(aws_security_group.sg.*.name, data.aws_security_group.selected.*.name, [""])[0]
}
