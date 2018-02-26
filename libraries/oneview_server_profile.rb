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

  # Missing method function which will get the snake_case method name and
  # check too see if tyhe attribute exists using the camelCase equivalent which is
  # what HP OneView returns
  #
  # @param symbol method_id The symbole of the methods that has been called
  #
  # @return [var] Value of the item that has been called
  def method_missing(method_id)
    # depedning on the method that has been called, determine what value should be returned
    bios_attrs = %w{ manage_bios overridden_settings }
    boot_attrs = %w{ manage_boot order }

    # determine the attrute to call
    method_name = camel_case(method_id)

    if bios_attrs.include?(method_id.to_s)
      bios.send(method_name)
    elsif boot_attrs.include?(method_id.to_s)
      boot.send(method_name)
    end
  end

  def respond_to_missing?(*)
    true
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

  def has_managed_bios?
    bios.manageBios
  end

  def has_bios_overrides?
    bios.overriddenSettings.empty? ? false : true
  end

  def has_managed_boot?
    boot.manageBoot
  end
end
