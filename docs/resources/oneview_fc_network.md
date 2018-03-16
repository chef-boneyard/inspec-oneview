---
title: About the oneview_fc_network resource
---

# oneview_fc_network

Use the `oneview_fc_network` InSpec audit resource to ensure that a Fibre Channel network within the OneView environment has been provisioned correctly.

# References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HPE OneView API Reference 300](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/fc-networks)

 # Syntax

 The name of the fibre channel network is required as a parameter to the resource.

```ruby
describe oneview_fc_network(name: 'MyNetwork') do
  its('property') { should eq 'value' }
end
```

where

* Resource parameters
  * `MyNetwork` - is the name of the fibre channel network as seen in HP OneView
* `property` is an attributes reyrned by the network resoiurce
* `value` is the expected value of the attribute

All attributes are references using snake_case, whereas the API will return camelCase attributes.

## Testers

There are a number of built in comparison operators that are available to test the result with an expected value.

For information on all that are available please refer to the [Inspec Matchers Reference](https://www.inspec.io/docs/reference/matchers/) page.

## Properties

This InSpec audti resource has the following properties that can be tested:

### have_auto_login_redistribution

Used for load balancing when logins are not evenly distributed over the Fibre Channel links, such as when an uplink that was previously down becomes available. Default value is `false`.

### category

Resource category used for authorizations and resource type groupings

### connection_template_uri

The connection template URI that is associated with this Fibre Channel network. This value must be null when creating a new Fibre Channel network.

### created

Date and time when the resource was created

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### description

Brief description of the resource

### e_tag

Entity tag/version ID of the resource, the same value that is returned in the ETag header on a GET of the resource 

### fabric_type

The supported Fibre Channel access method

| Values |
|---|
| DirectAttach |
| FabricAttach |

### link_stability_time

The time interval, expressed in seconds, to wait after a link that was previously offline becomes stable, before automatic redistribution occurs within the fabric. This value is not effective if autoLoginRedistribution is false. Default 30.

### managed_san_uri

The managed SAN URI that is associated with this Fibre Channel network. This value should be null for Direct Attach Fibre Channel networks and may be null for Fabric Attach Fibre Channel networks. 

### modified

Date and time when the resource was last modified

Format: YYYY-MM-DDThh:mm:ss.sssZ
Pattern: [1-2][0-9][0-9][0-9]-([0-1][0-9])-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](.[0-9][0-9][0-9])?Z

### name

Display name for the resource

### scope_uris

A list of URIs of the scopes to which the resource is assigned. Specific authorization is required to change the contents of the list. Note: This attribute is subject to incompatible changes in future release versions, including redefinition or removal.

### state

Current state of the resource

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