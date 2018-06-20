title 'OneView Enclsoure Group'

inspec_oneview_disable_affected_tests = attribute(:inspec_oneview_disable_affected_tests,default:1,description:'Flag to enable privileged resources requiring elevated privileges in GCP.')

control 'oneview-enclosure-group-1.0' do
  impact 1.0
  title 'Ensure that the Enclosure Group is configured correctly'

  only_if { inspec_oneview_disable_affected_tests.to_i == 0 }
  describe oneview_enclosure_group(name: 'InSpec-Enclosure-Group') do
    it { should have_associated_logical_interconnect_groups }
    it { should_not have_managed_os_deployment }

    its('enclosure_type') { should cmp 'SY12000' }

    its('type') { should cmp 'EnclosureGroupV300' }
    its('category') { should cmp 'enclosure-groups' }
    its('status') { should cmp 'OK' }
    its('state') { should cmp 'Normal' }
    its('stacking_mode') { should cmp 'Enclosure' }
    its('port_mapping_count') { should eq 8 }

    its('ip_addressing_mode') { should cmp 'DHCP' }
    its('power_mode') { should cmp 'RedundantPowerFeed' }
    its('description') { should be nil }

    its('os_deployment_mode') { should cmp 'None' }

    its('enclosureCount') { should be 1 }
  end
end