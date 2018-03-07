# frozen_string_literal: true
require 'oneview_backend'

class OneviewServerProfileConnections < OneviewResourceBase
  name 'oneview_server_profile_connections'

  desc 'InSpec resource to test the connections that have been assigned to a server profile'

  attr_accessor :probes

  # Define the filter table for the resource
  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:id)
        .add(:name)
        .add(:function_type)
        .add(:deployment_status)
        .add(:network_uri)
        .add(:port_id)
        .add(:requested_vfs)
        .add(:allocated_vfs)
        .add(:interconnect_uri)
        .add(:mac_type)
        .add(:wwpn_type)
        .add(:mac)
        .add(:wwnn)
        .add(:wwpn)
        .add(:requested_mbps)
        .add(:allocated_mbps)
        .add(:maximum_mbps)
        .add(:boot_priority)
        .add(:boot_initiator_name_source)
        .add(:boot_initiator_name)
        .add(:boot_initiator_ip)
        .add(:boot_initiator_subnet_mask)
        .add(:boot_initiator_gateway)
        .add(:boot_initiator_vlan_id)
        .add(:boot_target_name)
        .add(:boot_target_lun)
        .add(:boot_first_target_boot_ip)
        .add(:boot_first_boot_target_port)
        .add(:boot_second_boot_target_ip)
        .add(:boot_volume_source)
        .add(:boot_chap_level)
        .add(:boot_chap_name)
        .add(:boot_chap_secret)
        .add(:boot_mutual_chap_name)
        .add(:boot_mutual_chap_secret)

  filter.connect(self, :connection_details)

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, for example 'server-hardware'
    opts[:type] = 'server-profiles'
    super(opts)

    # abort if a name has not been specified
    abort 'Resource name must be specified when using the server_profile_connections InSPec resource' if opts[:name].nil?

    # find the servers
    resources
  end

  # Return information about the disks and add to the filter table so that
  # assertions can be performed
  def connection_details
    # Iterate around the connections of the profiler
    connections.each_with_index.map do |connection, index|
      parse_connection(connection, index)
    end if methods.include?('connections')
  end

  def parse_connection(resource, index)
    # Create a hash to hold the parsed data
    parsed = {
      number: index + 1,
    }

    # iterate around the keys and values of the resource to build up the 
    # parsed data
    resource.item.each do |key, value|
      # check the key to ensure that it has the correct format to read
      # from oneview
      # Most of the attributes can be converted from snake_case to snakeCase, but some of them do not follow
      # relevant conventions
      # For example converting `requestedVFs` to snake case would result in `requested_v_fs` which is incorrect
      # So this has to be caught and corrected
      if key == 'requestedVFs'
        api_name = 'requested_vfs'
      elsif key == 'allocatedVFs'
        api_name = 'allocated_vfs'
      else
        api_name = snake_case(key)
      end

      # check the key and if it is 'boot' iterate around the hash table creating
      # the necessary boot attributes
      if key == 'boot'
        value.each do |k, v|
          boot_attr_name = snake_case(k)
          boot_attr_name.start_with?('boot') ? api_name = boot_attr_name : api_name = format('boot_%s', boot_attr_name)
          parsed[api_name.to_sym] = v
        end
      else
        parsed[api_name.to_sym] = value
      end
    end

    # return the pased hash to the calling function
    parsed
  end
end
