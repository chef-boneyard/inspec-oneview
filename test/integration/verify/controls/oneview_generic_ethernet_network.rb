title 'OneView Generic Ethernet Network'

control 'oneview-generic-ethernet-network-1.0' do
  impact 1.0
  title 'Ensure that the Ethernet Network is configured correctly'

  describe oneview_generic_resource(type: 'ethernet-networks', name: 'InSpec-Ethernet-Network') do
    its('type') { should cmp 'ethernet-networkV300' }
    its('ethernet_network_type') { should cmp 'Tagged' }
    its('vlan_id') { should eq 1 }
    its('smart_link') { should be false }
    its('purpose') { should cmp 'General' }
    its('private_network') { should be false }
    its('subnet_uri') { should be nil }
    its('state') { should cmp 'Active' }
    its('status') { should cmp 'OK' }
    its('category') { should cmp 'ethernet-networks' }
  end
end
