data "kubectl_file_documents" "manifests" {
  content = var.yaml_body
}

resource "kubectl_manifest" "manifest" {
  count            = length(data.kubectl_file_documents.manifests.documents)
  yaml_body        = element(data.kubectl_file_documents.manifests.documents, count.index)
  wait             = true
  wait_for_rollout = true
  ignore_fields    = var.ignore_fields
}
