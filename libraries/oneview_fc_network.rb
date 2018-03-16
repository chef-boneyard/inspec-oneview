# frozen_string_literal: true
require 'oneview_backend'

class OneviewFcNetwork < OneviewResourceBase
  name 'oneview_fc_network'

  desc 'InSpec resource to test HP OneView Fibre Channel networks'

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, for example 'server-hardware'
    opts[:type] = 'fc-networks'
    super(opts)

    # find the servers
    resources
  end

  # Catch the calls to the specific attributes of the Fibre channel (FC) network. This allows the
  # simple elements to be interrogates using their snake_case equivalent
  #
  # @param symbol The symbol of the method that has been called
  #
  # @return Valueof the element that has been requested
  def method_missing(method_id)
    # determine the name of the method to call, by converting the id to camelCase
    method_name = camel_case(method_id)

    # if the method name is defined, call it otherwise raise an error
    if respond_to?(method_name)
      send(method_name)
    else
      super
      msg = format('undefined method `%s` for %s', method_id.to_s, self.class)
      raise NoMethodError, msg
    end
  end

  def respond_to_missing?(*)
    true
  end

  def has_auto_login_redistribution?
    autoLoginRedistribution
  end
end
