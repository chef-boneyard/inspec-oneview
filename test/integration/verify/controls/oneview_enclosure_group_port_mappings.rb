title 'OneView Enclsoure Group - Port Mappings'

inspec_oneview_disable_affected_tests = attribute(:inspec_oneview_disable_affected_tests,default:1,description:'Flag to enable privileged resources requiring elevated privileges in GCP.')

control 'oneview-enclosure-group-port-mappings-1.0' do
  impact 1.0
  title 'Check that the port mappings for an enclosure group are setup correctly'

  only_if { inspec_oneview_disable_affected_tests.to_i == 0 }
  describe oneview_enclosure_group_port_mappings(name: 'InSpec-Enclosure-Group').where(number: 1) do
    its('midplane_port') { should cmp 1 }
    its('interconnect_bay') { should cmp 1 }
  end
end