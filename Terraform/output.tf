resource "local_file" "azapp" {
  content  = jsonencode({ "endpoint" = azurerm_linux_web_app.azapp.default_hostname, "self_hosted_api_key" = var.infracost_self_hosted_api_key, "infracost_api_key" = var.infracost_api_key, "postgres_uri" = local.postgres_connection_string })
  filename = "output.json"
}