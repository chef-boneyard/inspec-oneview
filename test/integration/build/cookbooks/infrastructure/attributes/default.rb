# The attributes in this file define the settings for the infrastructure that is to be created in OneView

# Network Attributes
default['infrastructure']['network']['ethernet']['create'] = true
default['infrastructure']['network']['ethernet']['name'] = 'InSpec-Ethernet-Network'
default['infrastructure']['network']['ethernet']['vlanId'] = '3001'

default['infrastructure']['network']['fc']['create'] = true
default['infrastructure']['network']['fc']['name'] = 'InSpec-FC-Network'
default['infrastructure']['network']['fc']['associated_san'] = 'VSAN20'

# Logical Interconnect Groups Attributes
default['infrastructure']['lig']['ethernet']['create'] = true
default['infrastructure']['lig']['ethernet']['name'] = 'InSpec-LIG-Ethernet'
default['infrastructure']['lig']['ethernet']['uplink_name'] = 'InSpec-LIG - Ethernet - UplinkSet'
default['infrastructure']['lig']['ethernet']['side_a_bay'] = 3
default['infrastructure']['lig']['ethernet']['side_b_bay'] = 6
default['infrastructure']['lig']['ethernet']['port'] = 'Q1'
default['infrastructure']['lig']['ethernet']['icm_type'] = 'Virtual Connect SE 40Gb F8 Module for Synergy'
default['infrastructure']['lig']['ethernet']['enclosure_index'] = 1

default['infrastructure']['lig']['fc']['create'] = false
default['infrastructure']['lig']['fc']['name'] = 'InSpec-LIG-FC'
default['infrastructure']['lig']['fc']['uplink_name'] = 'InSpec-LIG - FC - Uplink Set'
default['infrastructure']['lig']['fc']['side_a_bay'] = 1
default['infrastructure']['lig']['fc']['side_b_bay'] = 4
default['infrastructure']['lig']['fc']['port'] = 'Q1:1'
default['infrastructure']['lig']['fc']['icm_type'] = 'Virtual Connect SE 16Gb FC Module for Synergy'
default['infrastructure']['lig']['fc']['enclosure_index'] = 1

# Enclosure Group Attributes
default['infrastructure']['enclosure_group']['create'] = false
default['infrastructure']['enclosure_group']['name'] = 'InSpec-Enclosure-Group'

# Server Profile Template Attributes
default['infrastructure']['server_profile_template']['create'] = false
default['infrastructure']['server_profile_template']['name'] = 'InSpec-Server-Profile-Template'
default['infrastructure']['server_profile_template']['server_hardware_type'] = 'SY 480 Gen9 1'
default['infrastructure']['server_profile_template']['volumes'] = [
  {
    volume_data: {
      name: 'InSpec-Volume-1',
      description: 'Storage volume created by InSpec',
      provisioningParameters: {
        provisionType: 'Full',
        requestedCapacity: 10737418240,
        shareable: false
      }
    },
    storage_system: 'ThreePAR-1',
    storage_pool: 'CPG-SSD',
    attachment_data: {
      id: 1,
      lunType: 'Auto',
      storagePaths: [
        {
          isEnabled: true,
          storageTargetType: 'Auto',
          connectionId: 2
        }
      ] 
    }
  }
]

# Server profile attributes
default['infrastructure']['server_profile']['create'] = false
default['infrastructure']['server_profile']['name'] = 'InSpec-Server-Profile'
default['infrastructure']['server_profile']['server_hardware'] = nil