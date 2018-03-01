---
title: About the oneview_server_profile_connections resource
---

# oneview_server_profile_connections

Use the `oneview_server_profile_connections` InSpec audit resource to test the network connections that a server profile has been allocated.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HP OneView API Reference 300 - Server Profiles](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/server-profiles)

## Syntax

This resource will return the specified connection from the specified server profile. The name must be provided using the resource parameter `name` and then the `where` method used to specify which network connection is of interest.

```ruby
describe oneview_server_profile_connections(name: 'MyServerProfileName').where(select: 'criteria')
  its('property') { should be 'value' }
end
```

where

* Resource Parameters
  * `MyServerProfileName` is the name of the Server Profile as seen in OneView
* Where criteria
  * `select` name of a property
  * `criteria` the value of the criteria property
* `property` is an attribute retuned by the connection
* `value` the expected value of the attribute

All attributes are references using camelCase, whereas the API will return snake_case attributes.

## Testers

There are a number of built in comparison operrtors that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audit resource has the following properties that can be tested:

### allocated_mbps

The transmit throughput (mbps) currently allocated to this connection. When Fibre Channel connections are set to Auto for requested bandwidth, the value can be set to -2000 to indicate that the actual value is unknown until OneView is able to negotiate the actual speed.

### allocated_vfs

The number of virtual functions allocated to this connection. This value will be null

### boot

Indicates that the server will attempt to boot from this connection. This object can only be specified if "boot.manageBoot" is set to 'true'. If the boot order is 'PXE' and the boot mode is 'UEFI', then there cannot be both iSCSI and PXE connections. If the boot order is 'HardDisk', then PXE connections will be configured to boot, but there will be no attempt to place them in the correct order. 

NOTE: To allow for easy testing _all_ the properties that are returned by OneView have `boot_` prefixed to them, except those that already have this in their name.

The follow properties are only available if the profile is set to boot from this connection.

#### boot_target_lun

The LUN number of the iSCSI target volume

#### boot_target_name

The unique identifier of the iSCSI target volume in iQN, EUI or NAA format. 

#### boot_volume_source

Indicates boot volume source for the connection. If Managed volume is selected, a boot volume must be identified in SAN storage section of the server profile. This attribute is required when creating FC boot connection. 

| Value | Description |
|---|---|
| AdapterBIOS | Boot from adapter BIOS volume parameters |
| ManagedVolume | Boot from a managed volume defined in SAN Storage section |
| UserDefined | Boot from user defined volume parameters |

#### boot_chap_level

The iSCSI Challenge Handshake Authentication Protocol (CHAP) method.

| Value | Description |
|---|---|
| Chap | The iSCSI target does the only authentication |
| MutualChap | The iSCSI target and the inititator authenticate each other |
| None | CHAP authentication is disabled. This is the default |

#### boot_chap_name

The iSCSI target username to be used when the target (storage system) authenticates the initiator (server). A valid name is 1-223 visible (letter, digit and punctuation) characters

#### boot_chap_secret

The iSCSI target secret/password to be used when the target (storage system) authenticates the initiator (server). A valid secret is either 12-16 printable (letter, digit, punctuation and space) characters with no '0x' prefix, or a '0x' followed by 24-32 hexadecimal (0-9a-fA-F) characters. A hexadecimal secret is only valid with the iSCSI function type.

A GET request does not return the CHAP secret. A PUT request with a new CHAP secret overwrites the existing CHAP secret. A PUT request without the CHAP secret is valid such that the existing secret is kept and not modified

#### boot_first_boot_target_ip

The IP address of the iSCSI target volume that is used first to attempt to connect. If the connection fails, then the secondBootTargetIp (if given) is used

#### boot_first_boot_target_port

The port number to be used for the iSCSI target volume designated by firstBootTargetIp. The default value is 3260 if firstBootTargetIp is specified

#### boot_initiator_gateway

The gateway for the iSCSI initiator.

#### boot_initiator_ip

The IPv4 address of the iSCSI initiator

#### boot_initiator_name

The unique identifier of the iSCSI initiator in iQN, EUI or NAA format. This field is ignored when initiatorNameSource is set to ProfileInitiatorName. This field is limited to alphanumeric characters plus the '-' (hyphen), '.' (period), and ':' (colon) characters. Letters must be lower case. This field must be the same for all connections if functionType is 'Ethernet' with iSCSI parameters and the connection is bootable

#### boot_initiator_name_source

Indicates how the iSCSI initiator name initiatorName was created. The default is ProfileInitiatorName.

| Value | Description |
|---|---|
| ProfileInitiatorName | The initiator name, initiatorName, was set on the profile level. |
| UserDefined | The initiator name, initiatorName, was defined by the user. |

#### boot_initiator_subnet_mask

The subnet mask of the iSCsi initiator

#### boot_initiator_vlan_id

The virtual LAN ID of the iSCSI initiator. This value is applicable only for connections of FunctionType 'iSCSI' that use tunneled networks and is optional

#### boot_mutual_chap_name

The iSCSI initiator username to be used when the initiator (server) authenticates the target (storage system). A valid name is 1-223 visible (letter, digit and punctuation) characters.

#### boot_mutual_chap_secret

The iSCSI initiator secret/password to be used when the initiator (server) authenticates the target (storage system). This secret should be different from chapSecret. A valid secret is either 12-16 printable (letter, digit, punctuation and space) characters with no '0x' prefix, or a '0x' followed by 24-32 hexadecimal (0-9a-fA-F) characters. A hexadecimal secret is only valid with the iSCSI function type.

A GET request does not return the Mutual-CHAP secret. A PUT request with a new Mutual-CHAP secret overwrites the existing CHAP secret. A PUT request without the Mutual-CHAP secret is valid such that the existing secret is kept and not modified

#### boot_priority

Indicates the boot priority for this device. PXE and Fibre Channel connections are treated separately; an Ethernet connection and a Fibre Channel connection can both be marked as Primary. The 'order' attribute controls ordering among the different device types.

| Value | Description |
|---|---|
| NotBootable | Boot is not attempted on this connection |
| Primary | Boot is first attempted on this connection |
| Secondary | Boot is attempted on this connection if boot from 'Primary' is unsuccessful |

#### boot_second_boot_target_ip

The IP address of the iSCSI target volume that is used (if given) if the connection designated by firstBootTargetIp fails. 

#### boot_second_boot_target_port

The port number to be used for the iSCSI target volume designated by secondBootTargetIp. The default value is 3260 if secondBootTargetIp is specified.

