# define attributes for the control
server_profile_name = attribute('server_profile_name', default: 'chef-esxi1')
connection_name = attribute('connection_name', default: 'Deployment Network A')
inspec_oneview_disable_affected_tests = attribute(:inspec_oneview_disable_affected_tests,default:1,description:'Flag to enable privileged resources requiring elevated privileges in GCP.')

title 'OneView Server Profile Connections'

control 'oneview-server-profile-connections-1.0' do
  impact 1.0
  title 'Ensure that the specified profile has the correct connections'

  only_if { inspec_oneview_disable_affected_tests.to_i == 0 }
  describe oneview_server_profile_connections(name: server_profile_name).where(name: connection_name) do
    its('id') { should cmp 1 }
    its('function_type') { should cmp 'Ethernet' }
    its('deployment_status') { should cmp 'Deployed' }
    its('requested_vfs') { should cmp 'Auto' }
    its('allocated_vfs') { should cmp 64 }
    its('wwpn_type') { should cmp 'Virtual' }
    its('wwnn') { should cmp nil }

    its('boot_priority') { should cmp 'Primary' }
    its('boot_target_lun') { should cmp 0 }
  end
end
