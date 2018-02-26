require_relative '../../libraries/oneview_backend'

class Test < Thor
  attr_reader :integration_tests_dir, :working_dir

  def initialize(*args)
    super
    # Set the necessary directories
    @integration_tests_dir = File.join(File.dirname(__FILE__), '..', '..', 'test', 'integration')
    @working_dir = File.join(integration_tests_dir, 'build')

    # Ensure that the terraform binary is available
    cmd_available = which('terraform')
    abort 'Terraform not found in the PATH. Please ensure it is installed and in the PATH' if cmd_available.nil?
  end

  desc 'integration', 'Perform integration tests'
  def integration
    init_workspace
    setup_integration
    execute
    cleanup
  end

  desc 'init_workspace', 'Initialize the Terraform workspace'
  def init_workspace
    say '----> Initialising', :green
    cmd = format('cd %s && terraform init', working_dir)
    result = `#{cmd}`
    say result
  end

  desc 'setup_integration', 'Setup the infrastructure for the Integration tests'
  def setup_integration
    # get the connection information for the Oneview instance
    oneview_backend = OneviewConnection.new
    config = oneview_backend.config

    say '----> Setting up Infrastructure', :green

    # CHange the correct directory to perform the terraform commands
    Dir.chdir(working_dir) do
      # Create the plan to be applied to OneView
      cmd = format('terraform plan -var "oneview_username=%s" -var "oneview_password=%s" -var "oneview_endpoint=%s" -out inspec-oneview.plan', config['user'], config['password'], config['url'])
      result = `#{cmd}`
      say result

      # apply the plan
      cmd = 'terraform apply inspec-oneview.plan'
      result = `#{cmd}`
      say result
    end
  end

  desc 'execute', 'Run the integration tests'
  def execute
    say '----> Executing Tests', :green
    cmd = format('chef exec inspec exec %s/verify', integration_tests_dir)
    result = `#{cmd}`
    say result
  end

  desc 'cleanup', 'Remove infrastructure created for integration tests'
  def cleanup
    # get the connection information for the Oneview instance
    oneview_backend = OneviewConnection.new
    config = oneview_backend.config

    say '----> Cleanup', :green

    Dir.chdir(working_dir) do
      cmd = format('terraform destroy -force -var "oneview_username=%s" -var "oneview_password=%s" -var "oneview_endpoint=%s"', config['user'], config['password'], config['url'])
      result = `#{cmd}`
      say result
    end
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
end
