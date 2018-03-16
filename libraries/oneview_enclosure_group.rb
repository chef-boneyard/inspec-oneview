# frozen_string_literal: true
require 'oneview_backend'

class OneviewEnclosureGroup < OneviewResourceBase
  name 'oneview_enclosure_group'

  desc 'InSpec audit resource to interrogate OneView Enclosure groups'

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, for example 'server-hardware'
    opts[:type] = 'enclosure-groups'
    super(opts)

    # find the servers
    resources
  end

  # Catch the calls to the specific attributes of the Enclsoure Group resource. This allows the simple
  # elements to be interrogated using their snake_case equivalent
  #
  # @param symbol The symbol of the method that has been called
  #
  # @return Value of the element that has been requested
  def method_missing(method_id)
    # determine the name of the method to call, by converting the method_id to camelCase
    method_name = camel_case(method_id)

    # if the method name is defined, call it otherwise raise an error
    if respond_to?(method_name) && methods.include?(method_name.to_sym)
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

  def has_associated_logical_interconnect_groups?
    associatedLogicalInterconnectGroups.empty? ? false : true
  end

  def os_deployment_mode
    osDeploymentSettings.deploymentModeSettings.deploymentMode
  end

  def has_managed_os_deployment?
    osDeploymentSettings.manageOSDeployment
  end

  def enclosure_type
    enclosureTypeUri.split(%r{\/}).last
  end
end
