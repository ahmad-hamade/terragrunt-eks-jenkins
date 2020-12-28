variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "yaml_body" {
  description = "YAML to apply to kubernetes"
  type        = string
}

variable "ignore_fields" {
  description = "List of map fields to ignore when applying the manifest"
  type        = list(string)
  default     = []
}
