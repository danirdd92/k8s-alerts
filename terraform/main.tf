provider "grafana" {
  url = "http://localhost:3000/"
  # auth = "user:password"
  # or service account
  auth = "glsa_LjrUzzXgsfV8gw0PhulPdXuZUMGsG9k3_bd5cc26e"
}

module "cert_manager_rules" {
  source = "github.com/mkilchhofer/terraform-grafana-prometheus-alerts"

  prometheus_alerts_file_path = file("/path/to/terraform/files")
  folder_uid                  = 1
  datasource_uid              = 1
}
