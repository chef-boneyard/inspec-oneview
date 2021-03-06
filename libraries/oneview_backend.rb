# frozen_string_literal: true
require 'inspec'

# @!parse
# Base class from which all Inspec resources are derived.
# This inherits from the Inspec resource
class OneviewResourceBase < Inspec.resource(1)
  attr_reader :opts, :client, :oneview

  # Constructor that retrievs a resource from Oneview
  #
  # The opts hash should contain the following:
  #   :type - Type of the resource to be interrogated
  #   :name - Name of the resource to look for _Optional_
  #
  # @author Russell Seymour
  #
  # @param [Hash] opts Hashtable of options as highlighted above
  def initialize(opts)
    # initialize variables
    @opts = opts
    @total = 0
    @counts = {}

    # Determine if the enviornment variables for the options have been set
    option_var_names = {
        name: 'ONEVIEW_RESOURCE_NAME',
        type: 'ONEVIEW_RESOURCE_TYPE',
    }
    option_var_names.each do |option_name, env_var_name|
      opts[option_name] = ENV[env_var_name] unless ENV[env_var_name].nil?
    end

    # Create the client
    @oneview = inspec.backend
    @client = oneview.oneview_client
  end

  def resources
    # Find the resources
    resources = oneview.resources(opts[:type],opts[:name])

    # process the resource differently based on whether there is one type of several returned
    if resources.count == 1
      @total = 1

      # Create the dynamic methods for each of the attributes that have been returned
      dm = OneviewResourceDynamicMethods.new
      dm.create_methods(self, resources.first)
    elsif resources.count > 1

      # create dynamic methods for each of the attributes that have been returned
      dm = OneviewResourceDynamicMethods.new
      dm.create_methods(self, resources)

      # now process the members of that have been returned
      @probes = resources['members'].map do |item|
        parse_resource(item)
      end.compact
    end
  end

  # Get the resource as referenced by the supplied uri
  #
  # @param string uri The uri to the resource
  # @param array filter Array of values that should be returned instead of the whole thing
  #
  # @return hash Hash of information about the target resource
  def resource(uri, filter = [])
    response = client.rest_get(uri)
    resource = client.response_handler(response)

    resource
  end

  # Given a string like `computer_name` return the camel case version, e.g. computerName
  #
  # @param string Data Data that needs to be converted from snake_case to camelCase
  #
  # @return string
  def camel_case(data)
    data = data.to_s if data.is_a? Symbol
    data.split('_').inject([]) { |buffer, e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end

  def snake_case(data)
    data.gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
  end
end

# Class to creae methods on the calling object at run time
# Each of the Oneview resources have different attributes and properties, and they all need to be
# testable. To do this no methods are hardcoded, each one is created based on the information
# returned by Oneview
#
# The class is a helper class essentially as it creates the methods on the calling class rather than
# itself. This means that there is less duplication of code and it can be reused easily
#
# @author Russell Seymour
class OneviewResourceDynamicMethods
  # Given the calling object and its data, create the methods on the object according
  # to the data that has been retrieved. Various types of data can be returned so the method
  # checks the type to enure that the necessary methods are configured correctly.
  #
  # @param [OneviewResourceProbe|OneviewResource] object The object on which the methods should be created
  # @param [Hash] data The data from which the methods should be created
  def create_methods(object, data)
    # Check the type of data as this affects the setup of the methods
    case data.class.to_s
    when 'Hash'
      data.each do |key, value|
        create_method(object, key, value)
      end
    end
  end

  private

  # Method that is responsible for creating the indivdual methods on the calling object. This is
  # because some nesting maybe required. For example if the value is a Hash then it will need
  # to have a OneviewResourceProbe created for each key, whereas if it is a scalar value then
  # the value just needs to be returned
  #
  # @private
  #
  # @param OneviewResourceProbe|OneviewResource object Object on which the methods need to be created
  # @param string name The name of the method
  # @param variant valuye The value that needs to be returned by the method
  def create_method(object, name, value)
    # Create the necessary method based on the var that has been passed
    # Test the value for its type so the method can be setup correctly
    case value.class.to_s
    when 'String', 'Integer', 'TrueClass', 'FalseClass', 'NilClass'
      object.define_singleton_method name do
        value
      end
    when 'Hash'
      value.count == 0 ? return_value = value : return_value = OneviewResourceProbe.new(value)
      object.define_singleton_method name do
        return_value
      end
    when 'Array'
      # Check the first element data type
      case value[0].class.to_s
      when 'String', 'Integer', 'TrueClass', 'FalseClass', 'Fixnum', 'NilClass'
        probes = value
      when 'Hash'
        probes = []
        value.each do |value_item|
          probes << OneviewResourceProbe.new(value_item)
        end
      end

      object.define_singleton_method name do
        probes
      end
    end
  end
end

# Class object that is created for each element that is returned by Oneview.
# This is what is interrogated by InSpec. If they are nested hahaes, then this results in
# nested OneviewResourceProbe objects
#
# The methods for each of the classes are dynamically defined at run time and will match
# the items that are returned from Oneview. See the 'test/integration/controls' for examples
#
# This class will not be called externally
#
# @author Russell Seymour
#
# @attr_reader string item The item that has been returned from Oneview
class OneviewResourceProbe
  attr_reader :item

  # Initialize method for the class. Accepts and item, be it scalar or hash
  # It will then created the necessary dynamic methods so that they can be called in the tests
  # This is accomplished by calling the OnviewDynamicMethods class
  #
  # @param [variant] The item from which the the class' methods will be created
  #
  # @return OneviewResourceProbe
  def initialize(item)
    dm = OneviewResourceDynamicMethods.new
    dm.create_methods(self, item)

    # Set the item as a property on the class
    # This is so that it is possible to interrogate what has been added to the class and isolate them
    # from the standard methids that a Ruby class has
    # This used for checking if arrays (for example) contain certain values
    # It also allows direct access if so required
    @item = item
  end

  # Allows resources to respone to the include test
  # This means that anything that has an array of values, a value can be looked for therein
  #
  # @author Russell Seymour
  #
  # @param [String] key Name of the key to look for in the @item property
  def include?(key)
    @item.key?(key)
  end
end
