---
title: About the oneview_generic_resource Resource
---

# oneview_generic_resource

Use the `oneview_generic_resource` InSpec audit resource to test any valid HP OneView resource. This is very useful if you need to test seomthing that we do not yet have a specific InSpec resource for.

## References

 - [Ruby SDK to Interact with HPE OneView](https://github.com/HewlettPackard/oneview-sdk-ruby)

## Syntax

```ruby
describe oneview_genric_resource(type: 'MyResourceType', name: 'MyResourceName') do
  its('property') { should eq 'value' }
end
```

where

 * Resource Parameters
   * `MyResourceType` the type of HP OneView resource being sought. (See below)
   * `MyResourceName` the name of the resource being tested
 * `property` This generic resource dynamically creates the properties at interrogation time based on the type of resource that is being targeted.
 * `value` is the expected output from the chosen property.

The options that can be passed to the resource are as follow.

| Name | Description |
|---|---|
| type: | Type of HP OneView to find. Use the REST API reference page to determine the types that are accepted - http://h17007.www1.hpe.com/docs/enterprise/servers/oneview3.0/cic-api/en/api-docs/current/index.html |
| name: | Name of the resource |

These options can also be set using the environment variables:

 - `ONEVIEW_RESOURCE_TYPE`
 - `ONEVIEW_RESOURCE_NAME`

When the options have been set as well as the environment variables, the environment variables take priority.

## Properties

The properties that can be tested are entirely dependent on the OneView resource that is under scrutiny. That means the properties vary. The best way to see what is availble is to use the OneView Portal for the environment and look at the properties that are returned there. the other place to look is at the REST API reference page as detailed above.

This resource allows yout to test _any_ valid HP OneView resource. The trade off for this is that the langauge to check each item is not as natural as it would be for a static InSpec resource.

