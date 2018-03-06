class Test < Thor
  attr_reader :integration_tests_dir, :vendor_dir, :infrastructure_cookbook_dir

  def initialize(*args)
    super
    # Set the necessary directories
    @integration_tests_dir = File.join(File.dirname(__FILE__), '..', '..', 'test', 'integration')
    @infrastructure_cookbook_dir = File.join(integration_tests_dir, 'build', 'cookbooks', 'infrastructure')
    @vendor_dir = File.join(integration_tests_dir, 'build', 'vendor')

    # Ensure that the necessary binaries are available
    berks = which('berks')
    chef_client = which('chef-client')
    if berks.nil? || chef_client.nil?
      message = 'Please ensure that the following binaries are in your PATH.'
      message += "\n  berks" if berks.nil?
      message += "\n  chef-client" if chef_client.nil?
      message += "\nYou may need to install ChefDK"
      abort message
    end
  end

  desc 'integration', 'Perform integration tests'
  method_option :attributes, type: :string, default: nil
  def integration
    vendor_cookbooks
    setup options[:attributes]
    execute
    destroy options[:attributes]
  end

  desc 'vendor_cookbooks', 'Get necessary cookbooks to build infrastructure'
  def vendor_cookbooks
    say '----> Vendoring Cookbooks', :green
    Dir.chdir(infrastructure_cookbook_dir) do
      vendor_path = File.join('..', '..', 'vendor', 'cookbooks')
      cmd = format('berks vendor %s', vendor_path)
      result = `#{cmd}`
      say result
    end
  end

  desc 'setup_integration', 'Setup the infrastructure for the Integration tests'
  method_option :attributes, type: :string, default: nil
  def setup_integration
    setup options[:attributes]
  end

  desc 'execute', 'Run the integration tests'
  def execute
    say '----> Executing Tests', :green
    cmd = format('chef exec inspec exec %s/verify', integration_tests_dir)
    result = `#{cmd}`
    say result
  end

  desc 'cleanup', 'Remove infrastructure created for integration tests'
  method_option :attributes, type: :string, default: nil
  def cleanup
    destroy options[:attributes]
  end

  private

  # `which` method to check that required binaries are available
  #
  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext| 
        binary = File.join(path, format('%s%s', cmd, ext))
        return binary if File.executable?(binary) && !File.directory?(binary)
      }
    end
    nil
  end

  def setup(attributes)
    attributes_file = resolve_file(attributes)

    say '----> Setting up Infrastructure', :green

    # CHange the correct directory to perform the terraform commands
    Dir.chdir(vendor_dir) do
      # Create the plan to be applied to OneView
      cmd = format('chef-client -z -j %s -o recipe[infrastructure]', attributes_file)
      result = `#{cmd}`
      say result
    end
  end

  def destroy(attributes)
    attributes_file = resolve_file(attributes)

    say '----> Cleanup', :green

    Dir.chdir(vendor_dir) do
      cmd =  format('chef-client -z -j %s -o recipe[infrastructure::destroy]', attributes_file)
      result = `#{cmd}`
      say result
    end
  end

  def resolve_file(attributes)
    # Abort if the path to the attribnutes file has not been set
    abort 'Please set the path to the attributes file using the --attributes option' if attributes.nil?

    # get the absolute path to the attributes file
    attributes_file = File.expand_path(attributes)

    # Abort if the attributes file cannot be located
    abort 'Unable to find specified attributes file' if !File.exist?(attributes_file)

    attributes_file
  end
end
