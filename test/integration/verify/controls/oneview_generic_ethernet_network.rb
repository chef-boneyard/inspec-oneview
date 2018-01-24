title 'OneView Generic Ethernet Network'

control 'oneview-generic-ethernet-network-1.0' do
  impact 1.0
  title 'Ensure that the Ethernet Network is configured correctly'

  describe oneview_generic_resource(type: 'ethernet-networks', name: 'InSpec-Ethernet-Network') do
    its('type') { should cmp 'ethernet-networkV300' }
    its('ethernetNetworkType') { should cmp 'Tagged' }
    its('vlanId') { should eq 1 }
    its('smartLink') { should be false }
    its('purpose') { should cmp 'General' }
    its('privateNetwork') { should be false }
    its('subnetUri') { should be nil }
    its('state') { should cmp 'Active' }
    its('status') { should cmp 'OK' }
    its('category') { should cmp 'ethernet-networks' }
  end
end
