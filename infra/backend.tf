terraform {
  backend "azurerm" {
    resource_group_name  = "app-pih-pol-rg-tfstate-001"
    storage_account_name = "apppihpolsatfstate001"
    container_name       = "app-pih-pol-st-c-tfstate-001"
    key                  = "terraform.tfstate"
  }
}