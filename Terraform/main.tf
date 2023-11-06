resource "azurerm_resource_group" "rg" {
  name     = "infracost"
  location = "West Europe"
}

resource "azurerm_postgresql_flexible_server" "psql-server" {
  name                   = "infracost-psqlflexibleserver"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "14"
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "fw-rule" {
  name             = "my-fw-rule"
  server_id        = azurerm_postgresql_flexible_server.psql-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_postgresql_flexible_server_database" "psql-db" {
  name      = "cloud_pricing"
  server_id = azurerm_postgresql_flexible_server.psql-server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_service_plan" "sp" {
  name                = "sp-infracost"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B2"
}

resource "azurerm_linux_web_app" "azapp" {
  name                = "azapp-infracost"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.sp.location
  service_plan_id     = azurerm_service_plan.sp.id

  app_settings = {
    "INFRACOST_API_KEY"             = var.infracost_api_key
    "SELF_HOSTED_INFRACOST_API_KEY" = var.infracost_self_hosted_api_key
    "POSTGRES_URI"                  = local.postgres_connection_string
  }

  site_config {
    application_stack {
      docker_image_name   = "infracost/cloud-pricing-api:latest"
      docker_registry_url = "https://index.docker.io"
    }
    app_command_line = "npm run start"
  }
}