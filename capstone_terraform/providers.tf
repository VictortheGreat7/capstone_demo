# This file is used to define the providers for the terraform configuration.

terraform {
  required_providers {
    azuread = ">= 2.9.0"
    azurerm = ">= 3.0.0"
  }
}

provider "azurerm" {
  features {}
}