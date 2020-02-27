terraform {
    backend "azurerm" {
        resource_group_name  = "terraform"
        storage_account_name = "lowopsstorage"
        container_name       = "tfstate"
        key                  = "app-config-demo.tfstate"
    }
}

data "azurerm_client_config" "current" {
}

locals {
  application_name = "app-config-demo"
  location = "westeurope"
  caller_object_id = data.azurerm_client_config.current.object_id
}

provider "azurerm" {
  version = "1.44.0"
  tenant_id = var.tenant_id
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name = "rg-${local.application_name}"
  location = local.location

}

resource "azurerm_app_service_plan" "asp" {
  name = "asp-${local.application_name}"
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name  
  
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app" {
  name = "${local.application_name}"
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    AppConfig = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.appconfconn.id})"
  }
}

resource "azurerm_app_configuration" "appconf" {
  name = "appconf-${local.application_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location = local.location
}

resource "azurerm_key_vault" "kv" {
  name = "kv-${local.application_name}"
  tenant_id = var.tenant_id
  location = local.location 
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "kv-tf-policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = var.tenant_id
  object_id = local.caller_object_id

  secret_permissions = [
    "get",
    "set",
    "list",
    "delete"
  ]
}

resource "azurerm_key_vault_access_policy" "kv-app-policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = azurerm_app_service.app.identity.0.tenant_id
  object_id = azurerm_app_service.app.identity.0.principal_id

  secret_permissions = [
    "get",
  ]
}

resource "azurerm_key_vault_secret" "appconfconn" {
  name         = "app-conf-connectionstring"
  value        = azurerm_app_configuration.appconf.primary_read_key.0.connection_string
  key_vault_id = azurerm_key_vault.kv.id
}