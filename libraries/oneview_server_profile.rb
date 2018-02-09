# frozen_string_literal: true
require 'oneview_backend'

class OneviewServerProfile < OneviewResourceBase
  name 'oneview_server_profile'

  desc 'InSpec resource to test aspects of a Server Profile'

  attr_accessor :probes

  # Define the filter table for the resource
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }

  filter.connect(self, :probes) 
  
  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, in this case it is 'server-hardware'
    opts[:type] = 'server-profiles'
    super(opts)

    # find the servers
    resources
  end

  def parse_resource(resource)
    # Create a hash to hold the parsed data
    parsed = {}

    # iterate around the keys and values of the resource to build up the 
    # parsed data
    resource.each do |key, value|
      parsed[snake_case(key)] = value
    end

    # return the pased hash to the calling function
    parsed
  end
end
