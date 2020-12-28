output "manifests_name" {
  description = "List of manifest resources installed in cluster"
  value       = formatlist("kind: %s, Name: %s", kubectl_manifest.manifest.*.kind, kubectl_manifest.manifest.*.name)
}
