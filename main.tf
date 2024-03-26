// registering provider for Azure Red Hat OpenShift
resource "azurerm_resource_provider_registration" "reg-aro" {
  name = "Microsoft.RedHatOpenShift"
}

// Configure the Azure provider
data "azurerm_client_config" "cc" {}
// Azure AD Application and Service Principal for the Red Hat OpenShift cluster
data "azuread_client_config" "ad-cc" {}

resource "azuread_application" "sp" {
  display_name = "sp-aro"
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.sp.client_id
}

resource "azuread_service_principal_password" "pass" {
  service_principal_id = azuread_service_principal.sp.object_id
}

data "azuread_service_principal" "redhatopenshift" {
  // This is the Azure Red Hat OpenShift RP service principal id, do NOT delete it
  client_id = "f1dd0a37-89c6-4e07-bcd1-ffd3d43d8875"
}

// Network Contributor role assignment to the service principal
resource "azurerm_role_assignment" "role_network1" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

// Network Contributor role assignment to the Azure Red Hat OpenShift RP service principal
resource "azurerm_role_assignment" "role_network2" {
  scope                = azurerm_virtual_network.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.redhatopenshift.object_id
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-eastus-aro-poc"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "main_subnet" {
  name                 = "main-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/23"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_subnet" "worker_subnet" {
  name                 = "worker-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/23"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = "aro-poc"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  cluster_profile {
    domain  = "${var.domain}.${var.location}.aroapp.io"
    version = "4.13.23"
  }

  network_profile {
    pod_cidr     = "10.128.0.0/14"
    service_cidr = "172.30.0.0/16"
  }

  main_profile {
    vm_size   = "Standard_E4as_v4"
    subnet_id = azurerm_subnet.main_subnet.id
  }

  api_server_profile {
    visibility = "Public"
  }

  ingress_profile {
    visibility = "Public"
  }

  worker_profile {
    vm_size      = "Standard_E2s_v5"
    disk_size_gb = 128
    node_count   = 3
    subnet_id    = azurerm_subnet.worker_subnet.id
  }

  service_principal {
    client_id     = azuread_application.sp.client_id
    client_secret = azuread_service_principal_password.pass.value
  }

  depends_on = [
    azurerm_role_assignment.role_network1,
    azurerm_role_assignment.role_network2,
  ]
}

output "console_url" {
  value = azurerm_redhat_openshift_cluster.aro.console_url
}

