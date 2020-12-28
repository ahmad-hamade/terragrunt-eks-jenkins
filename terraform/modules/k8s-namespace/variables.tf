variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "namespace" {
  description = "K8S namespace name"
  type        = string
  default     = null
}

variable "namespace_config" {
  description = "Specify namespace labels and anotations "
  type = object({
    annotations = map(any)
    labels      = map(any)
  })
  default = null
}

variable "cpu_request" {
  description = "Container CPU Request in a namespace"
  default     = "400m"
}

variable "memory_request" {
  description = "Container Memory Request in a namespace"
  default     = "500M"
}

variable "cpu_limit" {
  description = "Container CPU Limit in a namespace"
  default     = "800m"
}

variable "memory_limit" {
  description = "Container Memory Limit in a namespace"
  default     = "1Gi"
}
