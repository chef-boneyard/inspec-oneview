---
title: About the oneview_enclosure_group Resource
---

# oneview_enclosure_group

Use the `oneview_enclosure_group` InSpec audti resource to ensure that an enclosure group has been setup correctly. This allows the testing of interconnects and port mappings, although these do require the use of additional InSpec resources and will be called out where appropriate.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HPE OneView API Reference 300](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/enclosure_groups)

## Syntax

The name of the enclosure group is requires as a parameter to the resource. If a name is not specified the test will be aborted.

```ruby
describe oneview_enclosure_group(name: 'MyEnclosureGroup') do
  its('property') { should eq 'value' }
end
```

where

* Resource Parameters
  * `MyEnclosureGroup` is the name of the enclosure group as seen in HP Oneview.
* `property` is an attributes returned by the enclosure group
* `value` is the expected value of the attribute

## Testers

There are a number of built in comparison operators that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audit resource has the following properties that can be tested

### have_associated_logical_interconnect_groups

This allows for a simple boolean test to see if interconnect groups have been assigned to the enclosure group. For example.

```ruby
describe oneview_enclosure_group(name: 'InSpec-Enclosure-Group') do
  it { should have_associated_logical_interconnect_groups }
end
```

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

### enclosure_count

The number of enclosures in the enclosure group.

### enclosure_type_uri

The type of enclosures the group contains. 

### interconnect_bay_mappings

Defines which logical interconnect group is associated with each interconnect bay in which enclosure. This indicates the network connectivity that will be available to each bay. 

In order to test the the individual bay mappings the resource [`oneview_enclosure_group_interconnect_bay_mappings`](oneview_enclosure_group_interconnect_bay_mappings.md) should be used.

### ip_addressing_mode

Not used in the C7000 enclosure.

### ip_range_uris

Not used in the C7000 enclosure.

### modified

Date and time when the resource was last modified

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### name

The name of the enclosure group

### os_deploymnt_mode

Specifies the OS deployment network configuration. None indicates that OS deployment is not configured. Internal indicates that the OS deployment network has frame link module MGMT ports directly connected to the interconnect uplink ports. External indicates that the OS deployment network is external to the enclosure: both frame link module MGMT ports and interconnect uplink ports are connected to a top-of-rack switch with a common VLAN on both ports. 

### have_managed_os_deployment

Indicates whether the OS deployment is enabled.

### port_mapping_count

The number of port mappings.

### port_mappings

Provides midplane port number to IO bay mapping.

In order to test the individual port mappings the resource [`oneview_enclosure_group_port_mappings`](oneview_enclosure_group_port_mappings.md) should be used.

### power_mode

Power mode of the enclosure group.

| Value | Description |
|---|---|
| RedundantPowerFeed | There are at least twice as many power supplies as are necessary (n + n). |
| RedundantPowerSupply | There is at least 1 more power supply than is necessary (n + 1). |

### stacking_mode

Stacking mode of the enclosure group. Currently only the Enclosure mode is supported.

| Value | Description |
|---|---|
| Enclosure | Enclsoure Mode |
| MultiEnclosure | Multi-enclosure mode |
| None | No Mode |
| SwitchPairs | Switch pairs mode |

### state

The current resource state of the enclosure group. Possible values are Pending, Failed and Normal. 

### status

Overall health status of the resource

| Value | Description |
|---|---|
| OK | indicates normal/informational behaviour |
| Disabled | indicates that a resource is not operational |
| Warning | needs attention soon |
| Critical | needs immediate attention |
| Unknown | shuld be avoided, but there may be rare occasions where status is unknown |

### type

Uniquely identifes the type of the JSON object

### uri

The canonical URI of the resource