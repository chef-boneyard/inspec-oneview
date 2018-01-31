title 'OneView Servers'

control 'oneview-servers-1.0' do
  impact 1.0
  title 'Ensure that the servers in OneView are at the correct rom version'

  describe oneview_servers do
    its('category') { should cmp 'server-hardware' }
    its('total') { should cmp 14 }
  end

  # Check the power state of all the servers
  describe oneview_servers.where { power_state != 'On' } do
    its('name') { should eq [] }
    its('power_state') { should eq [] }
  end

  describe oneview_servers.where { rom_version != 'I37 v2.52 (10/25/2017)' } do
    its('entries.length') { should cmp 0 }
    its('rom_version') { should eq [] }
    its('name') { should eq [] }
  end

  describe oneview_servers.where { mp_firmware_version != '2.55 Aug 16 2017' } do
    its('name') { should eq [] }
  end
end