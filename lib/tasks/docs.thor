require 'yard'

class Docs < Thor
  desc 'create', 'Create the YarDoc documentation'
  def create
    YARD::Rake::YardocTask.new do |t|
      t.files = ['libraries/*.rb']
    end
  end
end
