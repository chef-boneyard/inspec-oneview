title 'Oneview Ethernet Network'

control 'oneview-ethernet-network-1.0' do
  impact 1.0
  title 'Ensure that the Ethernet Network is configured correctly'

  describe oneview_ethernet_network(name: 'InSpec-Ethernet-Network') do
    it{ should be_private_network }

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
