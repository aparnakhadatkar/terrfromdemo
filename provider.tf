provider "azurerm" {
  features = {}

  # Optional: explicitly set environment variables if not already
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
