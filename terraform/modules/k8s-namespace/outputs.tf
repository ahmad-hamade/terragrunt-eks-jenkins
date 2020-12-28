output "namespace" {
  description = "The name of namespace created"
  value       = kubernetes_namespace.ns.metadata[0].name
}
