# frozen_string_literal: true

require 'oneview-sdk'

# Class to manage the connection to Oneview to retrieve information about the resources
#
# @author Russell Seymour
class OneviewConnection
  attr_reader :config

  # Constructor that reads the configuration file
  def initialize
    # If the INSPEC_ONEVIEW_SETTINGS environment has been specifid set the
    # settings file accordingly, otherwise set to the default
    oneview_settings_file = ENV['INSPEC_ONEVIEW_SETTINGS']
    if oneview_settings_file.nil?

      # The environment var has not been set so set to the default location
      oneview_settings_file = File.join(Dir.home, '.oneview', 'inspec')
    end

    # Ensure that the settings file exists
    if File.file?(oneview_settings_file)
      @config = OneviewSDK::Config.load(oneview_settings_file)
    else
      @config = nil
      warn format('%s was not found or is not accessible', oneview_settings_file)
    end
  end

  # Connect to OneView using the specified configuration file
  #
  # @author Russell Seymour
  def client
    return @client if defined?(@client)

    # Create the client using the SDK
    @client = OneviewSDK::Client.new(config)
  end
end

# @!parse
# Base class from which all Inspec resources are derived.
# This inherits from the Inspec resource
class OneviewResourceBase < Inspec.resource(1)
  attr_reader :opts, :client

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

    # Create a connection to Onvewiew
    oneview = OneviewConnection.new

    # Create the client
    @client = oneview.client
  end

  def resources
    # Determine the endpoint that needs to be called
    endpoint = format('/rest/%s', opts[:type])

    # Find the resources
    response = client.rest_get(endpoint)
    resources = client.response_handler(response)

    # Filter the resources by the name if it has been specified
    unless opts[:name].nil?
      resources = resources['members'].select { |r| r['name'] == opts[:name] }
    end

    # process the resource differently based on whether there is one type of several returned
    if resources.count == 1
      @total = 1

      # Create the dynamic methods for each of the attributes that have been returned
      dm = OneviewResourceDynamicMethods.new
      dm.create_methods(self, resources.first)
    else

      # create dynamic methods for each of the attributes that have been returned
      dm = OneviewResourceDynamicMethods.new
      dm.create_methods(self, resources)

      # now process the members of that have been returned
      @probes = resources['members'].map do |item|
        parse_resource(item)
      end.compact
    end
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
    when 'Array'
      # Check the first element data type
      case value[0].class.to_s
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
