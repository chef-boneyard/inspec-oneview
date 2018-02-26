# frozen_string_literal: true

require 'oneview_backend'

class OneviewServers < OneviewResourceBase
  name 'oneview_servers'

  desc 'InSpec resource to test multiple servers'

  attr_accessor :probes, :rom_version_regex

  # Define the filter table for the resoucre
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .add('asset_tag')
        .add('category')
        .add('created')
        .add('description')
        .add('e_tag')
        .add('form_factor')
        .add('licensing_intent')
        .add('location_uri')
        .add('memory_mb')
        .add('model')
        .add('modified')
        .add('mp_dns_name')
        .add('mp_firmware_version')
        .add('mp_ip_address')
        .add('mp_model')
        .add('name')
        .add('part_number')
        .add('port_map') # This needs to be extended as it will contain an array
        .add('position')
        .add('power_lock')
        .add('power_state')
        .add('processor_core_count')
        .add('processor_count')
        .add('processor_speed_mhz')
        .add('processor_type')
        .add('profile_network_settings_state')
        .add('refresh_state')
        .add('rom_version')
        .add('rom_version_type')
        .add('rom_version_type_version')
        .add('rom_version_version')
        .add('rom_version_date')
        .add('serial_number')
        .add('server_group_uri')
        .add('server_hardware_type_uri')
        .add('server_profile_uri')
        .add('short_model')
        .add('signature') # This is a hash
        .add('state')
        .add('state_reason')
        .add('status')
        .add('type')
        .add('uri')
        .add('uuid')
        .add('virtual_serial_number')
        .add('virtual_uuid')

  filter.connect(self, :probes)

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  # @author Russell Seymour
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, in this case it is 'server-hardware'
    opts[:type] = 'server-hardware'
    super(opts)

    # Set the rom version regular expression to extract out the item
    # @rom_version_regex = '^([^\s]+)\s([^\s]+)?\s?\(?(.*?)\)?$'
    @rom_version_regex = '^(?<type>\S+)\s+(?:(?<version>\S+)\s+\((?<date>\S+)\)|(?<date>\S+))$'

    # find the servers
    resources
  end

  def parse_resource(resource)
    # create a hash to hold the parsed data
    parsed = {}

    # iterate around the keys and values of the resource to build up
    # the parsed data
    resource.each do |key, value|
      parsed[snake_case(key)] = value

      # if the key is romVersion break it out into constituent parts
      next unless key == 'romVersion'

      components = value.match(rom_version_regex).named_captures

      # add in the different components so they can be tested
      parsed[format('%s_type', snake_case(key))] = components['type']

      # add another parameter that is the type version
      parsed[format('%s_type_version', snake_case(key))] = Gem::Version.new(components['type'].gsub(/[^0-9.]/, ''))

      # Strip the v off the version so that it can be turned into a comparable version number
      parsed[format('%s_version', snake_case(key))] = components['version'].nil? ? nil : Gem::Version.new(components['version'].gsub(/[^0-9.]/, ''))
      parsed[format('%s_date', snake_case(key))] = DateTime.strptime(components['date'], '%m/%d/%Y')
    end

    parsed
  end
end
