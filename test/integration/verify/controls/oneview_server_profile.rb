# define attributes for the control
server_profile_name = attribute('server_profile_name', default: 'chef-esxi3')

title 'OneView Server Profile'

control 'oneview-server-profile-1.0' do
  impact 1.0
  title 'Ensure that the specified profile is configured correctly'

  describe oneview_server_profile(name: server_profile_name) do
    its('affinity') { should cmp 'Bay' }
  end
end