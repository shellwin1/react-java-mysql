locals {
  prefix                               = "${var.project_code}-${var.location_code}-${var.env}"
  rg_name                              = "${local.prefix}-rg-001"
  vnet_name                            = "${local.prefix}-vnet-default-001"
  snet_name                            = "${local.prefix}-vnet-default-snet-main-001"
  acr_name_prefix                      = "${var.project_code}${var.location_code}${var.env}crdocker"
  aks_name                             = "${local.prefix}-aks-001"
  azurerm_log_analytics_workspace_name = "${local.prefix}-log-001"
}