# frozen_string_literal: true

require 'oneview_backend'

class OneviewEthernetNetwork < OneviewResourceBase
  name 'oneview_ethernet_network'

  desc 'InSpec resource to test HP OneView Ethernet Networks'

  # Constructore for the resource. This calls the parent constructor to
  # get the generic resource for the specified network. This will provide the documented
  # static methods
  #
  # @author Russell Seymour
  def initialize(opts = {})
    # The generic resource needs to know what is being looked for, in this case it is 'ethernet-networks'
    opts[:type] = 'ethernet-networks'
    super(opts)

    # find the networks
    resources
  end

  # Catch the calls to the specific attributes of the ethernet network. This allows the simple
  # attributes to be interrogated using their snake_case equivalent
  #
  # @param symbol The symbol of the method that has been called
  #
  # @return Value of the attribute that has been called
  def method_missing(method_id)
    # determine the name of the method to call, by converting the id to camelCase
    method_name = camel_case(method_id)

    # if the method name is defined call it, otherwise raise an error
    if respond_to?(method_name)
      send(method_name)
    else
      super
      msg = format('undefined method `%s` for %s', method_id, self.class)
      raise NoMethodError, msg
    end
  end

  def respond_to_missing?(*)
    true
  end

  # Is the network a private network?
  #
  # This allows the use of
  #   it { should be_private_network }
  # within the InSpec profile
  #
  # @return bool
  def private_network?
    send('privateNetwork')
  end
end
