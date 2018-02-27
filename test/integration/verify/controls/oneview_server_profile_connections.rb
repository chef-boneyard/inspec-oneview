# define attributes for the control
server_profile_name = attribute('server_profile_name', default: 'chef-esxi1')

title 'OneView Server Profile Connections'

control 'oneview-server-profile-connections-1.0' do
  impact 1.0
  title 'Ensure that the specified profile has the correct connections'

  describe oneview_server_profile_connections(name: server_profile_name).where(id: 1) do
    byebug
    its('deployment_status') { should cmp 'Deployed' }
  end
end
