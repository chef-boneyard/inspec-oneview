---
title: About the oneview_server_profile resource
---

# oneview_server_profile

Use the `oneview_server_profile` InSpec audit resource to test a specific server profile that has been deployed to OneView. This will allow you to check the running configuration of the server profile.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HP OneView API Reference 101 - Server Profiles](http://h17007.www1.hpe.com/docs/enterprise/servers/oneviewhelp/oneviewRESTAPI/content/images/api/index.html#rest/server-profiles)

## Syntax

This resource will return the resource as specified by the name parameter that must be given when using the resource.

```ruby
describe oneview_server_profile(name: 'MyServerProfileName') do
  its('property') { should eq 'value' }
end
```

where

* Resource Parameters
  * `MyServerProfileName` is the name of the Server Profile as seen in OneView
* `property` is an attrubute returned by OneView
* `value` is the expected value of the attribute

All attributes are references using camelCase, whereas the API will return snake_case attributes.

## Testers

There are a number of built in comparison operrtors that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audit resource has the following properties that can be tested:

### affinity

This identifies the behavior of the server profile when the server hardware is removed or replaced. This can be set to Bay or BayAndServer. 

This can be one of the following values:

| Value | Description |
|---|---|
| Bay | This profile remains with the device bay when the server hardware is removed or replaced. |
| BayAndServer | This profile is pinned to both the device bay and specific server hardware. |

### associated_server

The server hardware serial number the profile is pinned to when the affinity for the profile is set to BayAndServer.

### have_managed_bios

Indicates whether the BIOS settings are configured using the server profile. Value can be 'true' or 'false'. 

### have_bios_overrides

The BIOS settings to be modified. All omitted BIOS settings are reset to their factory default values. 

This attrubute can be used to see if there are any settings that have been overridden, e.g.

```ruby
it { should_not have_bios_overrides }
```

### bios_x

For an Bios overrides that have been specified, each one has been exposed with a prefix of `bios_`. Therefore if a BIOS setting of `pci_express` was set then this would be exposed as `bios_pci_express`.

```ruby
its('bios_pci_express') { should be true }
```

### have_managed_boot

Indicates whether the boot order is configured using the server profile. Value can be 'true' or 'false'. 

### order

Determines the order in which boot will be attempted on the available devices. This is equivalent to the ProLiant IPL. Possible values are 'CD', 'Floppy', 'USB', 'HardDisk', and 'PXE'. It is recommended that all values be included. 

The value returned is an array of strings. The `include` keyword can be used to ensure that a specific item is in the array.

If you need to check for the specific order of the boot then specify an array in the test, e.g.

```ruby
its ('order') { should eq ['PXE', 'HardDisk'] }
```

### have_managed_boot_mode

States if the boot mode is managed or not.

**NOTE: This is not documented on the HPE API website, its existence was found during development of this profile**

### pxe_boot_policy

**NOTE: This is not documented on the HPE API website, its existence was found during development of this profile**

### mode

**NOTE: This is not documented on the HPE API website, its existence was found during development of this profile**

### category

Identifies the resource category. This field should always be set to 'server-profiles'.

### connections

This is an array of hashes. If you wish to test the connections of the Server Profile please use the `server_profile_connections` resource.

### created

Date and time when the resource was created

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### description

The description of this Server Profile

### e_tag

Ensures that multiple updates do not unintentionally overwrite each other's changes. This value is automatically generated during profile creation and updated each time the profile is edited. The value should not be modified by the client.

### enclosure_bay

Identifies the enclosure device bay number that the Server Profile is currently assigned to, if applicable. 

### enclosure_group_uri

Identifies the enclosure group for which the Server Profile was designed. The enclosureGroupUri is determined when the profile is created and cannot be modified. 

### have_managed_firmware

Indicates that the server firmware is configured using the server profile. Value can be 'true' or 'false'. 

### have_firmware_force_installed

Force installation of firmware even if same or newer version is installed. Downgrading the firmware can result in the installation of unsupported firmware and cause server hardware to cease operation. Value can be 'true' or 'false'. 

### firmware_baseline_uri

Identifies the firmware baseline to be applied to the server hardware. Server firmware is not modified if `have_managed_firmware` is false. 

### in_progress

Indicates whether the task identified by the taskUri is currently executing. Value can be 'true' or 'false'. 

### initialize

Indicates whether the local storage controller should be reset to factory defaults before applying the local storage settings from the server profile. 

### have_managed_local_storage

Indicates whether the local storage settings are configured using the server profile.

### logical_drives

This is an array of drives that are attached to the server profile. Please use the `server_profile_logical_drives` to test the drives that are attached to the profile.

### mac_type

Specifies the type of MAC address to be programmed into the IO devices. The value can be 'Virtual', 'Physical', or 'UserDefined'. It cannot be modified after the profile is created. 

| Value | Default | Description |
|---|---|---|
| Physical | | The addresses are not overwritten when the profile is assigned and reflect the addresses in the hardware. |
| UserDefined | | The addresses are provided by the user. |
| Virtual | * | The addresses are allocated from a pre-defined range within the appliance GUID pools. |

### modified

Date and time when the resource was last modified

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### name

Unique display name of this Server Profile.

### host_os_type

The type of operating system of the host. 

### have_managed_san_storage

Identifies whether SAN storage is managed in this profile. Its value can be 'true' or 'false'. 

### have_san_volumes

States if the server profile has attached San Volumes or not. This is a boolean value.

### volume_attachments

This is an array of SAN volumes that are attached to the Server Profile. To test these volumes please use the `oneview_server_profile_volumes` resource.

### serial_number

A 10-byte value that is exposed to the Operating System as the server hardware's Serial Number. The value can be a virtual serial number, user defined serial number or physical serial number read from the server's ROM. It cannot be modified after the profile is created. 

### serial_number_type

Specifies the type of Serial Number and UUID to be programmed into the server ROM. The value can be 'Virtual', 'UserDefined', or 'Physical'. The serialNumberType defaults to 'Virtual' when serialNumber or UUID are not specified. It cannot be modified after the profile is created. 

| Value | Default | Description |
|---|---|---|
| Physical | | The addresses are not overwritten when the profile is assigned and reflect the addresses in the hardware. |
| UserDefined | | The addresses are provided by the user. |
| Virtual | Yes, if SerialNumber and uuid are not specified | The addresses are allocated from a pre-defined range within the appliance GUID pools. |

### server_hardware_type_uri

Identifies the server hardware type for which the Server Profile was designed. The serverHardwareTypeUri is determined when the profile is created and cannot be modified.

### server_hardware_uri

Identifies the server hardware to which the server profile is currently assigned, if applicable. 

### state

Current State of this Server Profile

### status

Overall health status of this Server Profile

### task_uri

URI of the task currently executing or most recently executed on this server profile.

### type

Identifies the resource type. This field should always be set to 'ServerProfileV3'.

### uri

URI of this Server Profile. The URI is automatically generated when the server profile is created and cannot be modified. 

### uuid

A 36-byte value that is exposed to the Operating System as the server hardware's UUID. The value can be a virtual UUID, user defined UUID or physical UUID read from the server's ROM. It cannot be modified after the profile is created. 

### wwn_type

Specifies the type of WWN address to be programmed into the IO devices. The value can be 'Virtual', 'Physical', or 'UserDefined'. It cannot be modified after the profile is created. 

| Value | Default | Description |
|---|---|---|
| Physical | | The addresses are not overwritten when the profile is assigned and reflect the addresses in the hardware. |
| UserDefined | | The addresses are provided by the user. |
| Virtual | * | The addresses are allocated from a pre-defined range within the appliance GUID pools. |