title 'Oneview Fibre Channel Network'

control 'oneview-fc-network-1.0' do
  impact 1.0
  title 'Ensure that the Fibre Channel network is configured correctly'

  describe oneview_fc_network(name: 'InSpec-FC-Network') do
    it { should have_auto_login_redistribution }

    its('type') { should cmp 'fc-networkV300' }
    its('fabric_type') { should cmp 'FabricAttach' }
    its('link_stability_time') { should be >= 30 }
    its('description') { should be nil }
    its('state') { should cmp 'Active' }
    its('status') { should cmp 'OK' }
    its('category') { should cmp 'fc-networks' }
  end
end