title 'OneView Enclsoure Group - Interconnect Bay Mappings'

control 'oneview-enclosure-group-interconnect-bay-mappings-1.0' do
  impact 1.0
  title 'Check that interconnect bays are configured correctly'

  describe oneview_enclosure_group_interconnect_bay_mappings(name: 'InSpec-Enclosure-Group').where(interconnect_bay: 1) do
    its('logical_interconnect_group_uri') { should cmp nil }
  end

=begin
  # This is commented out because of the issue of creating an enclsoure group with interconnects using the 
  # HPE OneView cookbook. This has been logged with HPE and a solution is being sought.
  # For the moment to run this test you need to modify the enclosure group manually to add the necessary interconnects
  describe oneview_enclosure_group_interconnect_bay_mappings(name: 'InSpec-Enclosure-Group').where(interconnect_bay: 3) do
    its('logical_interconnect_group_name') { should cmp 'InSpec-LIG-Ethernet' }
  end
=end
end