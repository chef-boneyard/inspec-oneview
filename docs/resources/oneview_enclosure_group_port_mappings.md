---
title: About the oneview_enclosure_group_port_mappings Resource
---

# oneview_enclosure_group_bay_mappings

Use the `oneview_enclosure_group_port_mappings` InSpec audit resource to check the port mappings that has been assigned in the enclosure group.

Provides midplane port number to IO bay mapping

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HPE OneView API Reference 300](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/enclosure_groups)

## Syntax

The name of the enclosure group is requires as a parameter to the resource. If a name is not specified the test will be aborted.

```ruby
describe oneview_enclosure_group_port_mappings(name: 'MyEnclosureGroup') do
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

### interconnect_bay

Interconnect bay

### midplane_port

Midplane port