#!/usr/bin/env rake

require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

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
