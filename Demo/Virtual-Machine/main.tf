terraform {
  required_version = ">=1.4.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
  }
}

data "azurerm_client_config" "current" {}

data "azuread_user" "current" {
  object_id = data.azurerm_client_config.current.object_id
}

locals {
  mandatory_tags = {
    "environment" = "demo"
    "description" = "Virtual Machine demo for KSU Vgs"
    "created_by"  = data.azuread_user.current.user_principal_name
  }
  tags = merge(local.mandatory_tags, var.tags)
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = true
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-ksu-vgs-vm-demo"
  location = var.location

  tags = local.tags
}

