data "azurerm_resource_group" "udacity" {
  name     = "Regroup_1rUH_o5rtuBpdoexQ"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-bigboy-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-bigboy-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-bigboy-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######
resource "azurerm_storage_account" "udacity" {
  name                     = "udacity-bigboy-storage-act"
  resource_group_name      = data.azurerm_resource_group.udacity.name
  location                 = data.azurerm_resource_group.udacity.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "udacity" {
  name                         = "udacity-bigboy-sql-server"
  resource_group_name          = data.azurerm_resource_group.udacity.name
  location                     = data.azurerm_resource_group.udacity.location
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"
}

resource "azurerm_service_plan" "udacity" {
  name                = "udacity-bigboy-service-plan"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_resource_group.udacity.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "udacity" {
  name                = "udacity-bigboy-web-app"
  resource_group_name = data.azurerm_resource_group.udacity.name
  location            = data.azurerm_service_plan.udacity.location
  service_plan_id     = azurerm_service_plan.udacity.id

  site_config {}
}