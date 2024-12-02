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
  auth = "admin:admin"
}

module "alert_converter" {
  source = "./modules/alert_converter"

  prometheus_alerts_file_path = file("${path.module}/files/alerts.yaml")
  folder_uid                  = "ae5qdfq4wjhmod"
  datasource_uid              = "PBFA97CFB590B2093"
}
