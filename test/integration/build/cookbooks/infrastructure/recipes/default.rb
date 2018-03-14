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
  api_variant: connection['api_variant'],
  ssl_enabled: connection['ssl_enabled']
}

# Create ethernet network
ethernet_network = node['infrastructure']['network']['ethernet']
oneview_ethernet_network ethernet_network['name'] do
  client my_client
  data(
    vlanId:  1,
    purpose: 'General',
    smartLink: false,
    privateNetwork: false,
    ethernetNetworkType: 'Tagged'
  )
  only_if { ethernet_network['create'] }
end

fc_network = node['infrastructure']['network']['fc']
oneview_fc_network fc_network['name'] do
  client my_client
  data(
    autoLoginRedistribution: true,
    fabricType: 'FabricAttach'
  )
  associated_san "#{fc_network['associated_san']}" unless fc_network['associated_san'].nil?
  only_if { fc_network['create'] }
end

# Create LIG for Ethernet
lig_ethernet = node['infrastructure']['lig']['ethernet']
oneview_logical_interconnect_group lig_ethernet['name'] do
  client my_client
  data(
    redundancyType: 'Redundant',
    interconnectBaySet: 3,
    enclosureIndexes: [1, 1],
    enclosureType: 'SY12000'
  )
  interconnects [
    { bay: lig_ethernet['side_a_bay'], type: "#{lig_ethernet['icm_type']}", enclosure_index: lig_ethernet['enclosure_index'] },
    { bay: lig_ethernet['side_b_bay'], type: "#{lig_ethernet['icm_type']}", enclosure_index: lig_ethernet['enclosure_index'] }
  ]
  uplink_sets [
    {
      data: {
        name: lig_ethernet['uplink_name'],
        networkType: 'Ethernet',
        ethernetNetworkType: 'Tagged'
      },
      connections: [
        { bay: lig_ethernet['side_a_bay'], port: "#{lig_ethernet['port']}", type: "#{lig_ethernet['icm_type']}", enclosure_index: lig_ethernet['enclosure_index'] },
        { bay: lig_ethernet['side_b_bay'], port: "#{lig_ethernet['port']}", type: "#{lig_ethernet['icm_type']}", enclosure_index: lig_ethernet['enclosure_index'] }
      ],
      networks: [
        "#{ethernet_network['name']}"
      ]
    }
  ]
  only_if { lig_ethernet['create'] }
end

# Configure FC uplink data
lig_fc = node['infrastructure']['lig']['fc']
oneview_logical_interconnect_group lig_fc['name'] do
  client my_client
  api_variant 'Synergy'
  data(
    redundancyType: 'Redundant',
    interconnectBaySet: 1,
    enclosureIndexes: [-1],
    enclosureType: 'SY12000'
  )
  interconnects [
    { bay: lig_fc['side_a_bay'], type: "#{lig_fc['icm_type']}", enclosure_index: lig_fc['enclosure_index'] },
    { bay: lig_fc['side_b_bay'], type: "#{lig_fc['icm_type']}", enclosure_index: lig_fc['enclosure_index'] }
  ]
  uplink_sets [
    {
      data: {
        name: lig_fc['uplink_name'],
        networkType: 'FibreChannel'
      },
      connections: [
        { bay: lig_fc['side_a_bay'], port: "#{lig_fc['port']}", type: "#{lig_fc['icm_type']}", enclosure_index: lig_fc['enclosure_index'] },
        { bay: lig_fc['side_b_bay'], port: "#{lig_fc['port']}", type: "#{lig_fc['icm_type']}", enclosure_index: lig_fc['enclosure_index'] }
      ],
      networks: [
        "#{fc_network['name']}"
      ]
    }
  ]
  only_if { lig_fc['create'] }
end

oneview_logical_interconnect_group 'InSpec-SAS-LIG' do
  client my_client
  api_variant 'Synergy'
  data(
    interconnectBaySet: 1
  )
  interconnects [
    { bay: 1, type: 'Synergy 12Gb SAS Connection Module' },
    { bay: 4, type: 'Synergy 12Gb SAS Connection Module' }
  ]
  action :nothing
end

# Create enclosure group
eg = node['infrastructure']['enclosure_group']
oneview_enclosure_group eg['name'] do
  client my_client
  data(
    stackingMode: 'Enclosure',
    interconnectBayMappingCount: 6,
    ipAddressingMode: 'DHCP'
  )
  logical_interconnect_groups [
    { name: "#{lig_ethernet['name']}", enclosureIndex: "#{lig_ethernet['enclosure_index']}" }
  ]
  only_if { eg['create'] }
end

# Create Server profile template
spt = node['infrastructure']['server_profile_template']
oneview_server_profile_template spt['name'] do
  client my_client
  enclosure_group eg['name']
  server_hardware_type spt['server_hardware_type']
  # volume_attachments spt['volumes']
  only_if { spt['create'] }
end

# Create a server profile
sp = node['infrastructure']['server_profile']
oneview_server_profile sp['name'] do
  client my_client
  server_profile_template spt['name']
  
  # Only set the server_hardware parameter if the attribute is not nil
  # This is required because the HPE OneView simulator does not have hardware that can be used
  server_hardware spt['server_hardware'] unless spt['server_hardware'].nil?

  only_if { sp['create'] }
end
