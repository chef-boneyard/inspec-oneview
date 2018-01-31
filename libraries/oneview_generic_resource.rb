# frozen_string_literal: true

require 'oneview_backend'

class OneviewGenericResource < OneviewResourceBase
  name 'oneview_generic_resource'

  desc 'InSpec resource to interrogate any resource type in OneView'

  attr_accessor :probes, :filter

  def initialize(opts = {})
    # Call the parent class constructor
    super(opts)

    # Raise an error if at least a type has not been specified
    raise 'A type of resource must be sepcified' if opts[:type].nil?

    # Get the resources
    resources
  end

  # Define the filter table so that the resource can be interrogated
  @filter = FilterTable.create
  @filter.add_accessor(:count)
         .add_accessor(:entries)
         .add_accessor(:where)
         .add_accessor(:contains)
         .add(:exist?, field: 'exist?')
         .add(:type, field: 'type')
         .add(:name, field: 'name')
         .add(:properties, field: 'properties')

  @filter.connect(self, :probes)

  def parse_resource(resource)
    # return a hash of information
    parsed = {
      'type' => resource['type'],
      'exist?' => true,
    }

    properties = OneviewResourceProbe.new(resource)
    parsed['properties'] = properties

    # add the name if one is present
    resource.key?('name') ? parsed['name'] = resource['name'] : parsed['name'] = nil

    parsed
  end
end
