# define attributes for the control
server_profile_name = attribute('server_profile_name', default: 'chef-esxi1')

title 'OneView Server Profile Connections'

control 'oneview-server-profile-connections-1.0' do
  impact 1.0
  title 'Ensure that the specified profile has the correct connections'

  describe oneview_server_profile_connections(name: server_profile_name).where(id: 1) do
    its('function_type') { should cmp 'Ethernet' }
    its('deployment_status') { should cmp 'Deployed' }
    its('requested_vfs') { should cmp 'Auto' }
    its('allocated_vfs') { should cmp 64 }
    its('wwpn_type') { should cmp 'Virtual' }
    its('wwnn') { should cmp nil }

    its('boot.priority') { should cmp 'Primary' }
  end
end
