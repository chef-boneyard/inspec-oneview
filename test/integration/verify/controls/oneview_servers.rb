# Define attributes for the control
# An example attribute file can be found in the attributes folder within integration.
# Please create a new one relevant to the infrastructure being tested
rom_version_attr = attribute('rom_version', default: 'I37 v2.52 (10/25/2017)', description: 'Version of the server hardware firmware to test for')
mp_firmware_version_attr = attribute('mp_firwmare_version', default: '2.55 Aug 16 2017', description: 'Version of the firmware installed on the iLO')
power_state_attr = attribute('power_state', default: 'On', description: 'Power state of the machines to look for')
server_count = attribute('server_count', default: 14, description: 'Number of servers to check against')

title 'OneView Servers'

control 'oneview-servers-1.0' do
  impact 1.0
  title 'Ensure that the servers in OneView are at the correct rom version'

  describe oneview_servers do
    its('category') { should cmp 'server-hardware' }
    its('total') { should > server_count }
  end

  # Check the power state of all the servers
  describe oneview_servers.where { power_state != power_state_attr } do
    its('name') { should eq [] }
    its('power_state') { should eq [] }
  end

  describe oneview_servers.where { rom_version != rom_version_attr } do
    its('entries.length') { should cmp 0 }
    its('rom_version') { should eq [] }
    its('rom_version_type') { should cmp 'I38' }
    its('name') { should eq [] }
  end

  describe oneview_servers.where { mp_firmware_version != mp_firmware_version_attr } do
    its('name') { should eq [] }
  end
end