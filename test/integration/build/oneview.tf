# Configure variables
variable "oneview_username" {}
variable "oneview_password" {}
variable "oneview_endpoint" {}
variable "oneview_server_hardware_type" {
  default = "SY 480 Gen9 1"
}

# An enclosure group needs to exist beforehand
# Although the provider is meant to support this, it does not work.
# This has been logged under issue https://github.com/HewlettPackard/terraform-provider-oneview/issues/46
variable "oneview_enclosure_group" {
  default = "TME_Synergy_R1"
}

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

# Create an Enclosure Group for the TerraForm infrastructure
# resource "oneview_enclosure_group" "enclosure_group_1" {
#  name = "InSpec-Enclosure-Group"
#}

# Create a server profile template from which a server profile can
# be created. This will allow testing to be as indepedent as possible
resource "oneview_server_profile_template" "template_1" {
  name = "InSpec-Server-Profile-Template"
  enclosure_group = "${var.oneview_enclosure_group}"
  server_hardware_type = "${var.oneview_server_hardware_type}"

  network {
    name = "InSPec-Ethernet-Network-Connection"
    function_type = "Ethernet"
    network_uri = "${oneview_ethernet_network.network_1.uri}"
  }
}
