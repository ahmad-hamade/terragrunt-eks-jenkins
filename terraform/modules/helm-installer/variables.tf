variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "release_name" {
  description = "Release name"
  type        = string
}

variable "repository" {
  description = "Repository URL where to locate the requested chart"
  type        = string
}

variable "chart" {
  description = "Chart name to be installed"
  type        = string
}

variable "chart_version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed"
  type        = string
  default     = null
}

variable "namespace" {
  description = "The namespace to install the release into. Defaults to `default` when the value is `null`"
  type        = string
  default     = null
}

variable "create_namespace" {
  description = "Create the namespace if it does not yet exist"
  type        = bool
  default     = false
}

variable "namespace_config" {
  description = "Specify namespace labels and anotatations when the variable `create_namespace` is set to true"
  type = object({
    annotations = map(any)
    labels      = map(any)
  })
  default = {
    annotations = null
    labels      = null
  }
}

variable "helm_values" {
  description = "Values in raw yaml to pass to helm. Values will be merged, in order"
  type        = string
  default     = null
}

variable "helm_sets" {
  description = "Value block with custom STRING values to be merged with the values yaml."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "helm_sets_sensitive" {
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff."
  type = list(object({
    path  = string
    value = string
  }))
  default = null
}
