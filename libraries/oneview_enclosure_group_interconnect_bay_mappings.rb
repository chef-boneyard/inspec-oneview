# frozen_string_literal: true
require 'oneview_backend'

class OneviewEnclosureGroupInterconnectBayMappings < OneviewResourceBase
  name 'oneview_enclosure_group_interconnect_bay_mappings'

  desc 'InSpec audit resource to interrogate the interconnect bay mappings'

  attr_accessor :probes

  # Define the filter table for the resource
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:interconnect_bay)
        .add(:logical_interconnect_group_uri)
        .add(:logical_interconnect_group_name)

  filter.connect(self, :bay_mapping_details)

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, for example 'server-hardware'
    opts[:type] = 'enclosure-groups'

    # abort if the name of the enclosure group has not been specified
    abort 'Name of the enclosure group must be specified' if opts[:name].nil?

    super(opts)

    # find the servers
    resources
  end

  def bay_mapping_details
    interconnectBayMappings.each.map do |bay_mapping|
      parse_bay_mapping(bay_mapping)
    end if methods.include?('interconnectBayMappings')
  end

  def parse_bay_mapping(oneview_resource)
    # Create a hash to hold the parsed data
    parsed = {}

    # iterate around the keys and values of the resource to build up the
    # parsed data
    oneview_resource.item.each do |key, value|
      parsed[snake_case(key).to_sym] = value

      if key == 'logicalInterconnectGroupUri' && value != nil
        interconnect_group = resource(value)

        # if an interconnect group has been found add information about it
        unless interconnect_group.empty?
          parsed[:logical_interconnect_group_name] = interconnect_group['name']
        end
      end
    end

    # return the pased hash to the calling function
    parsed
  end
end
