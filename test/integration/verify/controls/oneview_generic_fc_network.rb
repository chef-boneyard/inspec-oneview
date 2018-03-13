title 'OneView Generic FC Network'

control 'oneview-generic-fc-network-1.0' do
  impact 1.0
  title 'Ensure that the Fibre Channel network is configured correctly'

  describe oneview_generic_resource(type: 'fc-networks', name: 'InSpec-FC-Network') do
    its('autoLoginRedistribution') { should be true }
    its('type') { should cmp 'fc-networkV300' }
    its('fabricType') { should cmp 'FabricAttach' }
    its('linkStabilityTime') { should be >= 30 }
    its('description') { should be nil }
    its('state') { should cmp 'Active' }
    its('status') { should cmp 'OK' }
    its('category') { should cmp 'fc-networks' }
  end
end