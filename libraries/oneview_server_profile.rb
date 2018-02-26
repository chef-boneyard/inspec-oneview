# frozen_string_literal: true
require 'oneview_backend'

class OneviewServerProfile < OneviewResourceBase
  name 'oneview_server_profile'

  desc 'InSpec resource to test aspects of a Server Profile'

  attr_accessor :probes

  # Constructor for the resource. This calls the parent constructor
  # to get the generic resource for the all the servers in OneView.
  #
  def initialize(opts = {})
    # The generic resource needs to know what is being sought, in this case it is 'server-hardware'
    opts[:type] = 'server-profiles'
    super(opts)

    # find the servers
    resources

    # Call method to create bios_ methods that allow access to
    # any bios settings that have been overridden
    create_bios_methods
  end

  # Missing method function which will get the snake_case method name and
  # check too see if tyhe attribute exists using the camelCase equivalent which is
  # what HP OneView returns
  #
  # @param symbol method_id The symbol of the methods that has been called
  #
  # @return [var] Value of the item that has been called
  def method_missing(method_id)
    # depedning on the method that has been called, determine what value should be returned
    bios_attrs = %w{ manage_bios overridden_settings }
    boot_attrs = %w{ manage_boot order }
    firmware_attrs = %w{ firmware_baseline_uri force_install_firmware manage_firmware }

    # determine the attrute to call
    method_name = camel_case(method_id)

    if bios_attrs.include?(method_id.to_s)
      bios.send(method_name)
    elsif boot_attrs.include?(method_id.to_s)
      boot.send(method_name)
    elsif firmware_attrs.include?(method_id.to_s)
      firmware.send(method_name)
    end
  end

  def respond_to_missing?(*)
    true
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

  def has_managed_firmware?
    firmware.manageFirmware
  end

  def has_firmware_force_installed?
    firmware.forceInstallFirmware
  end

  private

  def create_bios_methods
    # iterate around the overriddenSettings hash and create a bios method for each
    bios.overriddenSettings.each do |name, value|
      method_name = format('bios_%s', name)
      define_singleton_method method_name do
        value
      end
    end
  end
end
