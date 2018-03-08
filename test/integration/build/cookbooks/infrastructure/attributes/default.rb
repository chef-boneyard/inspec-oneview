# The attributes in this file define the settings for the infrastructure that is to be created in OneView

# Network Attributes
default['infrastructure']['network']['name'] = 'InSpec-Ethernet-Network'
default['infrastructure']['network']['vlanId'] = '3001'

# Logical Interconnect Group Attributes
default['infrastructure']['lig']['name'] = 'InSpec-Logical-Interconnect-Group'
default['infrastructure']['lig']['uplink_name'] = 'InSpec-Logical-Interconnect-Group - UplinkSet'
default['infrastructure']['lig']['side_a_bay'] = 3
default['infrastructure']['lig']['side_b_bay'] = 6
default['infrastructure']['lig']['port'] = 'Q1'
default['infrastructure']['lig']['type'] = 'Virtual Connect SE 40Gb F8 Module for Synergy'
default['infrastructure']['lig']['enclosure_index'] = 1

# Enclosure Group Attributes
default['infrastructure']['enclosure_group']['name'] = 'InSpec-Enclosure-Group'

# Server Profile Template Attributes
default['infrastructure']['server_profile_template']['name'] = 'InSpec-Server-Profile-Template'
default['infrastructure']['server_profile_template']['server_hardware_type'] = 'SY 480 Gen9 1'