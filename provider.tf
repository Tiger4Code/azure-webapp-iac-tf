provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    storage_account_name = "noorterraformstatest"
    container_name       = "terraform-state"
    key                  = "noor-azure-web-iac.terraform.tfstate"
    access_key           = var.storage_account_access_key
  }
}

# STORAGE_ACCOUNT_ACCESS_KEY
variable "storage_account_access_key" {
  description = "The public SSH key to use for the virtual machine."
  type        = string
}
