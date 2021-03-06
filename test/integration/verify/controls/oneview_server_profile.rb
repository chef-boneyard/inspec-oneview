# define attributes for the control
server_profile_name = attribute('server_profile_name', default: 'chef-esxi1')
affinity = attribute('affinity', default: 'Bay')
boot_order = attribute('boot_order', default: 'HardDisk')
template_compliance = attribute('template_compliance', default: 'Compliant')
enclosure_bay = attribute('enclosure_bay', default: 1)
boot_mode = attribute('boot_mode', default: 'UEFIOptimized')
inspec_oneview_disable_affected_tests = attribute(:inspec_oneview_disable_affected_tests,default:1,description:'Flag to enable privileged resources requiring elevated privileges in GCP.')

title 'OneView Server Profile'

control 'oneview-server-profile-1.0' do
  impact 1.0
  title 'Ensure that the specified profile is configured correctly'

  only_if { inspec_oneview_disable_affected_tests.to_i == 0 }
  describe oneview_server_profile(name: server_profile_name) do
    it { should_not have_managed_bios }
    it { should_not have_bios_overrides }
    it { should have_managed_boot }
    it { should have_managed_boot_mode }
    it { should_not have_managed_firmware }
    it { should_not have_firmware_force_installed }
    it { should_not have_managed_san_storage }
    its('affinity') { should cmp affinity }
    its('order') { should include boot_order }
    its('order') { should eq [boot_order] }
    its('template_compliance') { should cmp template_compliance }
    its('enclosure_bay') { should be 1 }
    its('mac_type') { should cmp 'Virtual' }
    its('wwn_type') { should cmp 'Virtual' }
    its('serial_number_type') { should cmp 'Virtual' }
    its('category') { should eq 'server-profiles' }
    its('status') { should eq 'OK' }
    its('state') { should eq 'Normal' }
    its('in_progress') { should be false }
    its('pxe_boot_policy') { should cmp 'Auto' }
    its('mode') { should cmp boot_mode }
  end
end