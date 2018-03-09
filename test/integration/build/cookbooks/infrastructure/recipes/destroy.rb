connection = node['infrastructure']['connection']

my_client = {
  url: connection['url'],
  user: connection['username'],
  password: connection['password'],
  api_version: connection['api_version'],
  ssl_enabled: connection['ssl_enabled']
}

# Destroy resources in order
sp = node['infrastructure']['server_profile']
oneview_server_profile sp['name'] do
  client my_client
  action :delete
end

spt = node['infrastructure']['server_profile_template']
oneview_server_profile_template spt['name'] do
  client my_client
  action :delete
end

eg = node['infrastructure']['enclosure_group']
oneview_enclosure_group eg['name'] do
  client my_client
  action :delete
end

lig = node['infrastructure']['lig']
oneview_logical_interconnect_group lig['name'] do
  client my_client
  action :delete
end

network = node['infrastructure']['network']['ethernet']
oneview_ethernet_network network['name'] do
  client my_client
  action :delete
end