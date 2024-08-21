provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "noorstorageaccount2024"
    container_name       = "terraform-state"
    key                  = "noor-azure-web-iac.terraform.tfstate"
  }
}
