#
# Cookbook:: infrastructure
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# configure the client credentials
connection = node['infrastructure']['connection']

my_client = {
  url: connection['url'],
  user: connection['username'],
  password: connection['password'],
  api_version: connection['api_version'],
  ssl_enabled: connection['ssl_enabled']
}

# Attempt to create a network
network = node['infrastructure']['network']
oneview_ethernet_network network['name'] do
  client my_client
  data(
    vlanId:  "#{network['vlanId']}",
    purpose: 'General',
    smartLink: false,
    privateNetwork: false,
    ethernetNetworkType: 'Tagged'
  )
end

# Create a logical interconnect group
lig = node['infrastructure']['lig']
lig_uplink_data = {
  name: lig['uplink_name'],
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}
connections = [
  { bay: "#{lig['side_a_bay']}", port: "#{lig['port']}", type: "#{lig['type']}", enclosure_index: "#{lig['enclosure_index']}" },
  { bay: "#{lig['side_b_bay']}", port: "#{lig['port']}", type: "#{lig['type']}", enclosure_index: "#{lig['enclosure_index']}" }
]
oneview_logical_interconnect_group lig['name'] do
  client my_client
  api_variant 'Synergy'
  data(
    redundancyType: 'Redundant',
    interconnectBaySet: 3,
    enclosureIndexes: [1, 1],
    enclosureType: 'SY12000'
  )
  interconnects [
    { bay: "#{lig['side_a_bay']}", type: "#{lig['type']}", enclosure_index: "#{lig['enclosure_index']}" },
    { bay: "#{lig['side_b_bay']}", type: "#{lig['type']}", enclosure_index: "#{lig['enclosure_index']}" }
  ]
  uplink_sets [
    { data: lig_uplink_data, connections: connections, networks: ["#{network['name']}"] }
  ]
end

# Create enclosure group
eg = node['infrastructure']['enclosure_group']
oneview_enclosure_group eg['name'] do
  client my_client
  data(
    stackingMode: 'Enclosure',
    interconnectBayMappingCount: 3,
    ipAddressingMode: 'DHCP'
  )
  logical_interconnect_groups [
    { name: "#{lig['name']}", enclosureIndex: "#{lig['enclosure_index']}" }
  ]
end

# Create Server profile template
spt = node['infrastructure']['server_profile_template']
oneview_server_profile_template spt['name'] do
  client my_client
  enclosure_group eg['name']
  server_hardware_type spt['server_hardware_type']
end

