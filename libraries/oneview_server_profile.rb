# frozen_literal_string: true

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
    boot_mode_attrs = %w{ manage_mode mode pxe_boot_policy }
    firmware_attrs = %w{ firmware_baseline_uri force_install_firmware manage_firmware }
    local_storage_attrs = %w{ initialize manage_local_storage }
    san_storage_attrs = %w{ host_os_type manage_san_storage }

    # determine the attrute to call
    method_name = camel_case(method_id)

    if bios_attrs.include?(method_id.to_s)
      bios.send(method_name)
    elsif boot_attrs.include?(method_id.to_s)
      boot.send(method_name)
    elsif boot_mode_attrs.include?(method_id.to_s)
      boot_mode.send(method_name)
    elsif firmware_attrs.include?(method_id.to_s)
      firmware.send(method_name)
    elsif local_storage_attrs.include?(method_id.to_s)
      local_storage.send(method_name)
    elsif san_storage_attrs.include?(method_id.to_s)
      san_storage_atrrs.send(method_name)
    else
      send(method_name)
    end
  end

  def respond_to_missing?(*)
    true
  end

  # Allow InSpec to test of the profile has a managed bios
  #
  # it { should have_managed_bios }
  def has_managed_bios?
    bios.manageBios
  end

  # Allow InSpec to test if the profile has any bios overrides
  #
  # it { should have_bios_overrides }
  def has_bios_overrides?
    bios.overriddenSettings.empty? ? false : true
  end

  # Allows InSpec to test if the profile has a managed boot
  #
  # it { should have_managed_boot }
  def has_managed_boot?
    boot.manageBoot
  end

  # Allows InSpec to test of the profile has a managed boot mode
  #
  # it { should have_managed_boot_mode }
  def has_managed_boot_mode?
    bootMode.manageMode
  end

  # Does the profile manage the firmare of the server that it is deployed to
  #
  # it { should have_managed_firmware }
  def has_managed_firmware?
    firmware.manageFirmware
  end

  # SHould the profile force the specified version of the firmware onto the server
  # even if it means downgrading the firmware already there?
  #
  # it { should have_firmware_force_installed }
  def has_firmware_force_installed?
    firmware.forceInstallFirmware
  end

  # Does the profile have managed local storage?
  #
  # it { should have_managed_local_storage }
  def has_managed_local_storage?
    localStorage.manageLocalStorage
  end

  # Does the profile have managed SAN storage
  #
  # it { should have_managed_san_storage }
  def has_managed_san_storage?
    sanStorage.manageSanStorage
  end

  # Are there any SAN volumes attached?
  #
  # it { should have_san_volumes }
  def has_san_volumes?
    sanStorage.volumeAttachments.empty? ? false : true
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
