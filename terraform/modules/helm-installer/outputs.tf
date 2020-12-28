output "chart_version" {
  description = "Chart version installed"
  value = {
    chart_version = helm_release.installer.version
  }
}
