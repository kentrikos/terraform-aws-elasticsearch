provider "helm" {
  alias           = "logging"
  service_account = var.tiller_service_account

  kubernetes {
    config_context = var.cluster_context
  }
}