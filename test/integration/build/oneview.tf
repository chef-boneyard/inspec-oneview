# Configure variables
variable "oneview_username" {}

variable "oneview_password" {}
variable "oneview_endpoint" {}

# Configure the Oneview provider
provider "oneview" {
  ov_username = "${var.oneview_username}"
  ov_password = "${var.oneview_password}"
  ov_endpoint = "${var.oneview_endpoint}"
}

# Create an ethernet network
resource "oneview_ethernet_network" "network_1" {
  name                  = "InSpec-Ethernet-Network"
  vlan_id               = 1
  purpose               = "General"
  private_network       = false
  smart_link            = false
  ethernet_network_type = "Tagged"
}
