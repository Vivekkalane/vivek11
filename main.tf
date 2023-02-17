provider "azurerm" {
    features {}
}
resource "azurerm_resource_group" "Vivek_Cosmos" {
  location = "eastus"
  name = "Vivek_DB1"
  tags = {
    Name = "Vivek"
    Day = "6"
  }
}
