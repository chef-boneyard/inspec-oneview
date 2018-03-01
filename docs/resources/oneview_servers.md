---
title: About the oneview_servers resource
---

# oneview_servers

Use the `oneview_servers` InSpec audit resource to test the servers tha are configured in OneView. This will allow you to check the firmware version, hardware specifications and many more.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HP OneView API Reference 300 - Server Hardware](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/server-hardware)

## Syntax

This resource will return _all_ the servers that can be found in OneView. To limit the number returned or perform more specific tests on a smaller subset use the `where` option.

```ruby
describe oneview_servers.where { property != 'Value' } do
  its('property') { should eq 'value' }
end
```

where

* `property` is an attribute returned by OneView
* `value` is the expected value of the attribute

All attriubutes are referenced using camelCase, whereas the API will return snake_case attributes.

## Testers

There are a number of built in comparison operrtors that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audit resource has the following properties that can be tested:

### asset_tag

The current value of the asset tag for this server hardware. This value can be set in the server hardware's BIOS interface.

### category

Resource category used for authorizations and resource type groupings

### created

Date and time when the resource was created

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### description

Brief description of the resource

### e_tag

Entity tag/version ID of the resource, the same value that is returned in the ETag header on a GET of the resource

### form_factor

The physical dimensions of this server. For a blade server this is either HalfHeight or FullHeight. For a rack server this is expressed in U height, e.g. 4U

### licensing_intent

Product license assigned to the server hardware.

| Values | Description |
|---|---|
| OneView | HP OneView licenses |
| OneViewNoiLO | HP OneView w/o iLO licenses |

### location_uri

For blade servers, the enclosure in which this blade server resides. This URI can be used to retrieve information about the enclosure. This value is not set for rack mount servers.

### memory_mb

Amount of memory installed on this server hardware (in megabytes).

### model 

The full server hardware model string

### modified

Date and time when the resource was last modified

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### mp_dns_name

The DNS name of the iLO/Management Processor that resides on this server hardware.

### mp_firmware_version

The version of the firmware installed on the iLO.

### mp_ip_address

IP Address of the management processor (iLO) resident on this server hardware.

### mp_model

The model type of the iLO, such as iLO4

### name

The name of the server

### part_number

The part number for this server hardware

### port_map

TBD

### position

For blade servers, the number of the physical enclosure bay in which the server hardware resides. For rack mount servers, this value is null.

### power_lock

Indicates if an operation is being performed on this server hardware (such as a profile assignment) that prevents its power state from being manipulated via the server hardware API.

### power_state

Current power state of the server hardware. Values are Unknown, On, Off, PoweringOn, PoweringOff or Resetting.

| Value | Description |
|---|---|
| Off | Power Off |
| On | Power on |
| PoweringOff | Powering off |
| PoweringOn | Powering On |
| Resetting | Restting |
| Unknown | Unable to determine server power state |

### processor_core_count

Number of cores available per processor

### processor_count

Number of processors installed on this server hardware

### processor_speed_mhz

Speed of the CPUs in megahertz

### processor_type

Type of CPU installed on this server hardware

### profile_network_settings_state

Profile Network Settings State

### refresh_state

Indicates if the resource is currently refreshing. Possible values are NotRefreshing, RefreshPending, Refreshing, and RefreshFailed

| Value |  Description | 
|---|---|
| NotRefreshing | The resource is not currently refreshing |
| RefreshFailed | The refresh of this resource failed | 
| RefreshPending | The resource is waiting to be refreshed |
| Refreshing | The resource is currently being refreshed |

### rom_version

The version of the server hardware firmware (ROM). After updating the ROM (BIOS) firmware for a server, the server hardware page and the REST API may report an inaccurate ROM version until the server is next powered on and allowed to complete the power-on self-test (POST).

This version is normally in the following format:

`Ixx vx.xx mm/dd/YYYY` which maps onto `type version date`

The resource will split these out into components that can be tested indivdually.

#### rom_version_type

Returns the first part of the version component. This refers to the system type.

#### rom_version_version

Returns the version component. To make it easier to compare version numbers 

### serial_number

Serial number of the server hardware

### server_group_uri

For blade servers, this is the URI of the containing enclosure's enclosure group. This URI can be used to retrieve information about the enclosure group or to identify all the servers in the same group. This value is not set for rack mount servers.

### server_hardware_type_uri

URI of the server hardware type associated with the server hardware. This URI can be used to retrieve information about the server hardware type.

### server_profile_uri

URI of a server profile assigned to this server hardware, if one is assigned. If not assigned this value is null.

### short_model

Short version of the server hardware model string, typically something like BL460 Gen8.

### signature

TBD

### state

The current resource state of the server hardware. Allowable values are: Unknown (not initialized), Adding (server being added), NoProfileApplied (server successfully added), Unmanaged (discovered a supported server), Removing (server being removed), RemoveFailed (unsuccessful server removal), Removed (server successfully removed), ApplyingProfile (profile being applied to server), ProfileApplied (profile successfully applied), RemovingProfile (profile being removed), ProfileError (unsuccessful profile apply or removal), Unsupported (server model or version not currently supported by the appliance), and UpdatingFirmware (server firmware update in progress).

### state_reason

Indicates the reason the resource in its current state

### status

Overall health status of the resource. The following are the valid values for the status of the resource:
OK - indicates normal/informational behavior;

Disabled - indicates that a resource is not operational;

Warning - needs attention soon;

Critical - needs immediate attention.

Unknown - should be avoided, but there may be rare occasions where status is Unknown;

### type

Uniquely identifies the type of the JSON object

### uri

The canonical URI of the resource

### uuid

Universally Unique ID (UUID) of the server hardware.

### virtual_serial_number

Virtual serial number associated with this server hardware (if specified in the profile assigned to this server).

### virtual_uuid

Virtual UUID associated with this server hardware (if specified in the profile assigned to this server).