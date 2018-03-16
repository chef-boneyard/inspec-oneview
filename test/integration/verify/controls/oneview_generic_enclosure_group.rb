title 'OneView Generic Enclosure Group'

control 'oneview-generic-enclosure-group-1.0' do
  impact 1.0
  title 'Ensure that the Enclosure Group is configured correctly, using the OneView generic resource'

  # Use the generic resource to run tests against the enclsoure group
  describe oneview_generic_resource(type: 'enclosure-groups', name: 'InSpec-Enclosure-Group') do
    its('type') { should cmp 'EnclosureGroupV300' }
    its('category') { should cmp 'enclosure-groups' }
    its('status') { should cmp 'OK' }
    its('state') { should cmp 'Normal' }
    its('stackingMode') { should cmp 'Enclosure' }
    its('portMappingCount') { should eq 8 }

    its('enclosureTypeUri') { should include 'SY12000' }

    # Interrogate the portmappings array of hashes to check that they are
    # configured correctly
    its('portMappings.first.midplanePort') { should eq 1 }
    its('portMappings.first.interconnectBay') { should eq 1}

    its('interconnectBayMappingCount') { should eq 6 }
    its('interconnectBayMappings.first.interconnectBay') { should eq 1 }
    its('interconnectBayMappings.first.logicalInterconnectGroupUri') { should eq nil }

    its('ipAddressingMode') { should cmp 'DHCP' }
    its('ipRangeUris.count') { should be 0 }
    its('powerMode') { should cmp 'RedundantPowerFeed' }
    its('description') { should be nil }

    its('osDeploymentSettings.deploymentModeSettings.deploymentNetworkUri') { should be nil }
    its('osDeploymentSettings.deploymentModeSettings.deploymentMode') { should cmp 'None' }
    its('osDeploymentSettings.manageOSDeployment') { should be false }

    its('enclosureCount') { should be 1 }
    its('associatedLogicalInterconnectGroups.length') { should be 0 }
  end
end