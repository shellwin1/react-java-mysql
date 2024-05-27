resource "azurerm_resource_group" "main" {
  location = var.location
  name     = local.rg_name
}

resource "azurerm_virtual_network" "default" {
  address_space       = ["10.52.0.0/16"]
  location            = var.location
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = local.snet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.default.name
}

resource "random_string" "acr_suffix" {
  length  = 4
  numeric = true
  special = false
  upper   = false
}

resource "azurerm_container_registry" "main" {
  location            = var.location
  name                = "${local.acr_name_prefix}${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Premium"

  retention_policy {
    days    = 7
    enabled = true
  }
}

module "aks" {
  source  = "Azure/aks/azurerm" // https://registry.terraform.io/modules/Azure/aks/azurerm/latest
  version = "8.0.0"

  cluster_name                         = local.aks_name
  cluster_log_analytics_workspace_name = local.azurerm_log_analytics_workspace_name
  prefix                               = local.prefix
  resource_group_name                  = azurerm_resource_group.main.name
  kubernetes_version                   = "1.27" # don't specify the patch version!
  automatic_channel_upgrade            = "patch"
  attached_acr_id_map                  = {
    main = azurerm_container_registry.main.id
  }
  network_plugin  = "azure"
  network_policy  = "azure"
  os_disk_size_gb = 60
  sku_tier        = "Standard"
  rbac_aad        = false
  vnet_subnet_id  = azurerm_subnet.main.id

  depends_on = [azurerm_resource_group.main]
}