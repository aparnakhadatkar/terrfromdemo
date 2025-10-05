resource azurerm_resource_group "main" {
 name  =  "myrg05102025"
 location  =  "eastus"
}

resource azurerm_storage_account "main" {
 name                    = "str05102025"
 resource_group_name      = azurerm_resource_group.main.name
 location                = azurerm_resource_group.main.location
 account_tier            = "Standard"
 account_replication_type = "LRS"

}

resource azurerm_virtual_network "main" {
 name                    = "myvnet05203035"
 resource_group_name     = azurerm_resource_group.main.name
 location                = azurerm_resource_group.main.location
 address_space           = ["10.0.0.0/16"]
}

resource azurerm_subnet "main" {
 name                 = "mysubnet05203035"
 resource_group_name  = azurerm_resource_group.main.name
 virtual_network_name = azurerm_virtual_network.main.name
 address_prefixes       = ["10.0.1.0/24"]
}  

resource azurerm_public_ip "main" {
 name               = "mypip05203035"
 location           = azurerm_resource_group.main.location
 resource_group_name = azurerm_resource_group.main.name
 allocation_method  = "Dynamic"
}

## Network Interface
resource azurerm_network_interface "main" {
    name               = "mynic05203035"
    location           = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration { 
     name                         = "ipconfig1"
     subnet_id                    = azurerm_subnet.main.id
     private_ip_address_allocation = "Dynamic"
     public_ip_address_id         = azurerm_public_ip.main.id      

    }
}

## Virtual Machine 

resource azurerm_virtual_machine "main" {
 name                  = "myvm05203035"
 location              = azurerm_resource_group.main.location
 resource_group_name   = azurerm_resource_group.main.name
 vm_size                  = "standard_B2s"
 admin_username        = "azureuser"
 admin_password        = "Password.1!!"
 network_interface_ids = azurerm_network_interface.main.id

 storage_os_disk {
    name                  = "win-os-disk"
    caching               = "read-only"
    storage_account_type  = "standard-LRS"
 }

 source_image_referance {
   publisher            = "MicrosoftWindowsServer"
   offer                = "WindowsServer"
   Sku                  = "2029-Datacenter"
   version              = "lastest"
 }
}

## Kubernet Cluster

resource azurerm_kubernetes_cluster "main" {
    name                  = "ask-demo"
    location              = azurerm_resource_group.main.location
    resource_group_name   = azurerm_resource_group.main.name
    dns_prefix            = "aksdemo"

    default_node_pool {
        name          = "default"
        node_count    = 1
        vm_size       = "Standar_d2s_v3"
    }

    identity {
        type  = "SystemAssigned"
    }
}
