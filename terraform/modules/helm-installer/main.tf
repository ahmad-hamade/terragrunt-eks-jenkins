resource "kubernetes_namespace" "ns" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = var.namespace_config.annotations
    labels      = var.namespace_config.labels
    name        = var.namespace
  }
}

resource "helm_release" "installer" {
  name             = var.release_name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.create_namespace ? kubernetes_namespace.ns[0].metadata[0].name : var.namespace
  version          = var.chart_version
  create_namespace = false
  cleanup_on_fail  = true
  force_update     = false
  recreate_pods    = true
  wait             = true
  timeout          = 800 # TODO: To be revisited again https://github.com/hashicorp/terraform-provider-helm/issues/463

  values = var.helm_values == null ? [] : [var.helm_values]

  dynamic "set" {
    iterator = item
    for_each = var.helm_sets == null ? [] : var.helm_sets

    content {
      name  = item.value.name
      value = item.value.value
    }
  }

  dynamic "set_sensitive" {
    iterator = item
    for_each = var.helm_sets_sensitive == null ? [] : var.helm_sets_sensitive

    content {
      name  = item.value.path
      value = item.value.value
    }
  }
}
