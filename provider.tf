provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "noorterraformstatest"
    container_name       = "terraform-state"
    key                  = "noor-azure-web-iac.terraform.tfstate"
    # Can also be set via `ARM_ACCESS_KEY` environment variable.
    # access_key           = "abcdefghijklmnopqrstuvwxyz0123456789..."  
  }
}

# STORAGE_ACCOUNT_ACCESS_KEY
# variable "storage_account_access_key" {
#   description = "The public SSH key to use for the virtual machine."
#   type        = string
# }
