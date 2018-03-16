---
title: About the oneview_enclosure_group_bay_mappings Resource
---

# oneview_enclosure_group_bay_mappings

Use the `oneview_enclosure_group_bay_mappings` InSpec audit resource to check the bay mappings that has been assigned in the enclosure group.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)
 - [HPE OneView API Reference 300](http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html#rest/enclosure_groups)

## Syntax

The name of the enclosure group is requires as a parameter to the resource. If a name is not specified the test will be aborted.

```ruby
describe oneview_enclosure_group_bay_mappings(name: 'MyEnclosureGroup') do
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

### enclosure_index

If specified, this value identifies the enclosure [1..enclosureCount] to which this interconnect bay mapping applies. If omitted, the interconnect bay mapping applies to all enclosures in the group. 

### interconnect_bay

Enclosure interconnect bay number

### logical_interconnect_group_uri

URI of the logical interconnect group resource associated with the interconnect bay.

### logical_interconnect_group_name

The name of the interconnect group that is assigned to this bay.

This is a derived value that uses the `logical_interconnect_group_uri` to get the Logical Interconnect Group from OneView and surfaces the name for testings. This is currently the only property that is surfaced from the referenced group.

## Example

The following example shows how to select the bay of interest and then test to ensure that the correct group has been assigned.

```ruby
describe oneview_enclosure_group_interconnect_bay_mappings(name: 'InSpec-Enclosure-Group').where(interconnect_bay: 3) do
  its('logical_interconnect_group_name') { should cmp 'InSpec-LIG-Ethernet' }
end
```

Note the use of the `where` method to select the bay of interest.