#!/usr/bin/env rake

require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

# Include library for connecting to OneView
require_relative 'libraries/oneview_backend'

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

    # Create the plan to be applied to OneView
    Dir.chdir(working_dir) do
      cmd = format("terraform plan -var 'oneview_username=%s' -var 'oneview_password=%s' -var 'oneview_endpoint=%s' -out inspec-oneview.plan", config['user'], config['password'], config['url'])
      sh(cmd)
    end
  end

end