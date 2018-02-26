require 'erb'

class Generate < Thor
  desc 'resource NAME DESCRIPTION TYPE', 'Create a new InSpec OneView resource'
  method_option :multiple, type: :boolean, default: false
  def resource(name, description, type)
    # Get the current directory of the task
    current_dir = File.expand_path(File.dirname(__FILE__))

    # Use the current dir to work out the path to the templates and
    # the resource directory
    template_dir = File.expand_path(File.join(current_dir, '..', 'templates'))
    resources_dir = File.expand_path(File.join(current_dir, '..', '..', 'libraries'))

    # Determine the path of the resource file
    resource_file = File.join(resources_dir, format('%s.rb', name))

    # Read in the template file
    template_file = File.join(template_dir, 'resource.rb.erb')
    template = File.read(template_file)

    # work out some of the variables that will be used
    class_name = snake_to_camel_case(name)

    renderer = ERB.new(template)
    File.write(resource_file, renderer.result(binding))
  end

  private

  def snake_to_camel_case(str, mode: :class)
    case mode
    when :class
      str.split('_').map(&:capitalize).join
    when :method
      str.split('_').inject { |m, p| m + p.capitalize }
    else
      raise "unknown mode #{mode.inspect}"
    end
  end
end
