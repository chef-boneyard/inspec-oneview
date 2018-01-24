---
title: About the oneview_ethernet_network Resource
---

# oneview_ethernet_network

Use the `oneview_ethernet_network` InSpec audit resource to ensure that a network within Oneview has been provisioned correctly.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)

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

### type

The type of ethernet network. For an ethernet network this will return `ethernet-networkVX` where X is the API version that is being used.

### ethernet_network_type

Returns the type of ethernet network type. For example `Tagged`.

### vlan_id

The ID of the VLan that the network has been assigned.

### purpose

Returns a string representing what the network is to be used for. This is an arbitary value that is set at creation time. The default value is `General`.

### connection_template_uri

The URI to the connection template. This is the REST URI to the ID of the template that is being used for the connection.

`/rest/connection-template/a974c750-fc48-4b09-95b4-edde918d5a29`

### fabric_uri

The URI to the fabric that is being used. This is the REST URI to the ID of the fabric that is being used.

`/rest/fabric/3970ebcb-a553-48dc-b1ba-4d4ab4210b09`

### private_network

Boolean stating if the network is a private network.

When this is `true` the network is configured so that all downlink ports connected to the network are prevented from communicating with each other in the logical interconnect.

```ruby
its('private_network') { should be false }
```

### be_private_network

This helper method provides another way to chekc if the network is private or not. Compare the following syntax with the previous helper:

```ruby
it { should_not be_private_network }
```

### subnet_uri

Returns the URi to the subet attached to the network. If this is not set then the value is `nil`.

### scope_uris

Array of scope URIs

### description

A description applied to the network. If not set the value is `nil`.

### name

Name of the network

### state

String representing the state of the network. If up and running this will return `Active`.

### status

String representing the Status of the network

### e_tag

Returns a GUID of the entity tag / version ID oif the resource

### created

String representing when the network was created. 

This is the format `YYYY-MM-DDTHH:mm:ss.sssZ`

### modified

String representing when the network was last modified. 

This is the format `YYYY-MM-DDTHH:mm:ss.sssZ`

### category

Category of the resource within Oneview. In this case it will be `ethernet-networks`.

### uri

The REST URI to this resource, e.g. `/rest/ethernet-networks/0a00d6a4-cabc-4cc1-ac8b-8043b52a9f52`.

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





