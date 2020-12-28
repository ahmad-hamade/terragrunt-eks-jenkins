resource "kubernetes_namespace" "ns" {
  metadata {
    annotations = var.namespace_config.annotations
    labels      = var.namespace_config.labels
    name        = var.namespace
  }
}

resource "kubernetes_limit_range" "limits" {
  metadata {
    name      = "default-limit-range"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default_request = {
        cpu    = var.cpu_request
        memory = var.memory_request
      }

      default = {
        cpu    = var.cpu_limit
        memory = var.memory_limit
      }
    }
  }
}
