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

  prometheus_alerts_file_path = file("${path.module}/files/alerts.yaml")
  folder_uid                  = "need to create a folder and check the uid via the api before running this!"
  datasource_uid              = "prometheus"
}
