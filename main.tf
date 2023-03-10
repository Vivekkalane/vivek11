provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
variable "location" {
  default = "eastus"
}
variable "name" {
  default = "vivek-cosmos"
}
variable "throughput" {
  type        = number
  description = "Cosmos db database throughput"
  validation {
    condition     = var.throughput >= 400 && var.throughput <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.throughput % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}
resource "azurerm_resource_group" "vivek-cosmos" {
  location = var.location
  name = var.name
  tags = {
    Name = "Vivek"
    Day = "5"
  }
}
resource "azurerm_cosmosdb_account" "GlobalDocumentDB" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.vivek-cosmos.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
}
resource "azurerm_cosmosdb_sql_database" "vivek-cosmos" {
  name                = var.name
  resource_group_name = azurerm_resource_group.vivek-cosmos.name
  account_name        = azurerm_cosmosdb_account.GlobalDocumentDB.name
  throughput          = var.throughput
}
resource "azurerm_cosmosdb_sql_container" "vivek-cosmos" {
  name                  = var.name
  resource_group_name   = azurerm_resource_group.vivek-cosmos.name
  account_name          = azurerm_cosmosdb_account.GlobalDocumentDB.name
  database_name         = azurerm_cosmosdb_sql_database.vivek-cosmos.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  throughput            = var.throughput
}
