#!/usr/bin/env rake

require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

# Include library for connecting to OneView
require_relative 'libraries/oneview_backend'

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
  return nil
end

# rubocop
desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

# Lint the project
desc 'Run rubocop linter'
task lint: [:rubocop]

# run tests
task default: [:lint]

# Documentation tasks
YARD::Rake::YardocTask.new do |t|
  t.files = ['libraries/*.rb']
end

# Integration tests
namespace :test do

  # Specify the directory for the integration tests
  integration_tests_dir = File.join(File.dirname(__FILE__), 'test', 'integration')
  working_dir = File.join(integration_tests_dir, 'build')

  # Ensure that the terraform binary is available
  cmd_available = which('terraform')
  if cmd_available.nil?
    abort "Terraform not found in the PATH. Please ensure it is installed and in the PATH"
  end

  # Initialize the terraform workspace
  task :init_workspace do
    cmd = format('cd %s && terraform init', working_dir)
    sh(cmd)
  end

  # Setup the infrastructure for running the tests
  task :setup_integration_tests do

    # get the connection information for the Oneview instance
    oneview_backend = OneviewConnection.new
    config = oneview_backend.config

    puts '----> Setup'
    puts working_dir

    Dir.chdir(working_dir) do
      # Create the plan to be applied to OneView
      cmd = format('terraform plan -var "oneview_username=%s" -var "oneview_password=%s" -var "oneview_endpoint=%s" -out inspec-oneview.plan', config['user'], config['password'], config['url'])
      sh(cmd)

      # apply the plan 
      cmd = 'terraform apply inspec-oneview.plan'
      sh(cmd)
    end
  end

  task :run_integration_tests do
    puts "----> Run"

    cmd = format("chef exec inspec exec %s/verify", integration_tests_dir)
    sh(cmd)
  end

  task :cleanup_integration_tests do
    # get the connection information for the Oneview instance
    oneview_backend = OneviewConnection.new
    config = oneview_backend.config

    puts '----> CLeanup'   
    
    Dir.chdir(working_dir) do
      cmd = format('terraform destroy -force -var "oneview_username=%s" -var "oneview_password=%s" -var "oneview_endpoint=%s"', config['user'], config['password'], config['url'])
      sh(cmd)
    end
  end

  desc 'Perform Integration Tests'
  task :integration do 
    Rake::Task["test:init_workspace"].execute
    Rake::Task["test:cleanup_integration_tests"].execute
    Rake::Task["test:setup_integration_tests"].execute
    Rake::Task["test:run_integration_tests"].execute
    Rake::Task["test:cleanup_integration_tests"].execute    
  end

end