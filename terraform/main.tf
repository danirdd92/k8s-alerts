terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "3.13.2"
    }
  }
}


provider "grafana" {
  url  = "http://localhost:3000"
  auth = "admin:prom-operator"
}

module "alert_converter" {
  source = "./modules/alert_converter"

  prometheus_alerts_file_path = file("/home/dani/cw/k8s-alerts/terraform/files/*.yaml")
  folder_uid                  = 1
  datasource_uid              = 1
}
