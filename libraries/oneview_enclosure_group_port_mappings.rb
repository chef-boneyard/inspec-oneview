# frozen_string_literal: true
require 'oneview_backend'

class OneviewEnclosureGroupPortMappings < OneviewResourceBase
  name 'oneview_enclosure_group_port_mappings'

  desc 'InSpec audit resource to test the port mappings of an enclosure group'

  attr_accessor :probes

  # Define the filter table for the resource
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:number)
        .add(:midplane_port)
        .add(:interconnect_bay)

  filter.connect(self, :port_mapping_details)

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

  # Iterate around all the of port mappings for the enclosure group and build
  # up the FilterTable so that test assertions can be performed
  def port_mapping_details
    # Iterate around the port_mappings of the enclosure_group
    portMappings.each_with_index.map do |port_mapping, index|
      parse_port_mapping(port_mapping, index)
    end if methods.include?('portMappings')
  end

  def parse_port_mapping(resource, index)
    # Create a hash to hold the parsed data
    parsed = {
      number: index + 1,
    }

    # iterate around the keys and values of the resource to build up the 
    # parsed data
    resource.item.each do |key, value|
      parsed[snake_case(key).to_sym] = value
    end

    # return the pased hash to the calling function
    parsed
  end
end
