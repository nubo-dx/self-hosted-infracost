locals {
  postgres_connection_string = "postgres://${azurerm_postgresql_flexible_server.psql-server.administrator_login}:${azurerm_postgresql_flexible_server.psql-server.administrator_password}@${azurerm_postgresql_flexible_server.psql-server.name}.postgres.database.azure.com:5432/${azurerm_postgresql_flexible_server_database.psql-db.name}?sslmode=require"
}
