require 'rubocop/rake_task'

class Lint < Thor
  desc 'rubocop', 'Run Rubocop lint checks'
  def rubocop
    RuboCop::RakeTask.new
  end
end
