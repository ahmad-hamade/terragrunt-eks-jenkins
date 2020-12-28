terraform {
  required_version = ">= 0.12"
  required_providers {
    aws        = ">= 3.0"
    helm       = ">= 2.0"
    kubernetes = ">= 1.13"
  }
}
