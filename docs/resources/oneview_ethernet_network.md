---
title: About the oneview_ethernet_network Resource
---

# oneview_ethernet_network

Use the `oneview_ethernet_network` InSpec audit resource to ensure that a network within Oneview has been provisioned correctly.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HPE OneView API Reference 300](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/ethernet-networks)

## Syntax

The name of the network is required as a parameter to the resource.

```ruby
describe oneview_ethernet_network(name: 'MyNetwork') do
  its('property') { should eq 'value' }
end
```

where

* Resource Parameters
  * `MyNetwork` is the name of the ethernet network as seen in HP Oneview.
* `property` is one of
  - [`type`](#type)
  - [`ethernet_network_type`](#ethernet_network_type)

## Testers

There are a number of built in comparison operrtors that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audit resource has the following properties that can be tested:

### category

Resource category used for authorizations and resource type groupings.

### connection_template_uri

The URI of the existing connection template associated with the network. This value must be null when creating a new network.

`/rest/connection-template/a974c750-fc48-4b09-95b4-edde918d5a29`

### created

Date and time when the resource was created

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### description

Brief description of the resource 

### e_tag

Entity tag/version ID of the resource, the same value that is returned in the ETag header on a GET of the resource 

### ethernet_network_type

The type of Ethernet network. It is optional. If this field is missing or its value is Tagged, you must supply a valid vlanId; if this value is Untagged or Tunnel, please either ignore vlanId or specify vlanId equals 0. This value cannot be changed once created.

| Value | Description |
|---|---|
| ImageStreamer | An image deployment network |
| NotApplicable | The enclosure type is not applicable |
| Tagged | A tagged ethernet network |
| Tunnel | A tunneled ethernet network |
| Unknown | The enclosure type is unknown |
| untagged | An untagged ethernet network |

### fabric_uri

The URI to the fabric that is being used. This is the REST URI to the ID of the fabric that is being used.

`/rest/fabric/3970ebcb-a553-48dc-b1ba-4d4ab4210b09`

### modified

Date and time when the resource was last modified

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### name

Display name for the resource

### private_network

When enabled, the network is configured so that all downlink (server) ports connected to the network are prevented from communicating with each other within the logical interconnect. Servers on the network only communicate with each other through an external L3 router that redirects the traffic back to the logical interconnect. 

```ruby
its('private_network') { should be false }
```

### be_private_network

This helper method provides another way to chekc if the network is private or not. Compare the following syntax with the previous helper:

```ruby
it { should_not be_private_network }
```

### purpose

A description of the network's role within the logical interconnect

| Value | Description |
|---|---|
| FaultTolerence | For fault tolerance purposes |
| General | For general purposes |
| ISCSI | |
| Management | For management purposes |
| VMMigration | For VM migration purposes |

### scope_uris

A list of URIs of the scopes to which the resource is assigned. Specific authorization is required to change the contents of the list.

### smart_link

When enabled, the network is configured so that, within a logical interconnect, all uplinks that carry the network are monitored. If all uplinks lose their link to external interconnects, all corresponding dowlink (server) ports which connect to the network are forced into an unlinked state. This allows a server side NIC teaming driver to automatically failover to an alternate path. 

### state

Current state of the resource

### status

Overall health status of the resource. The following are the valid values for the status of the resource: 

| Value | Description |
|---|---|
| OK | Indicates normal/informational behaviour |
| Disabled | indicates that a resource is not operational |
| Warning | needs attention soon |
| Critical | needs immediate attention |
| Unknown | Should be avoided, but there may be rare occasions where status is Unknown |

### subnet_uri

Returns the URi to the subet attached to the network. If this is not set then the value is `nil`.

### type

Uniquely identifies the type of the JSON object.

### uri

The canonical URI of the resource

### vlan_id

The Virtual LAN (VLAN) identification number assigned to the network. The VLAN ID is optional when ethernetNetworkType is Untagged or Tunnel. Multiple Ethernet networks can be defined with the same VLAN ID, but all Ethernet networks in an uplink set or network set must have unique VLAN IDs. The VLAN ID cannot be changed once the network has been created. 

# Examples

The following examples show how to use this InSpec audit resource.

Please refer to the integration tests fo more in-depth examples:

 - [Ethernet Network](../../test/integration/verify/controls/oneview_ethernet_network.rb)

 ## Test that the network is tagged and is active

 ```ruby
  describe oneview_ethernet_network(name: 'InSpec-Ethernet-Network') do
  its('ethernet_network_type') { should cmp 'Tagged' }
  its('state') { should cmp 'Active' }
end
 ```





