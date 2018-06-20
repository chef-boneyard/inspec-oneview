source 'https://rubygems.org'

gem 'oneview-sdk'

group :development do
  gem 'yard'
  gem 'thor'
  gem 'rubocop'
  gem 'rake'
  # below was required to work with Chef DK 2.5.3
  gem 'activesupport', '= 5.1.5'
  gem 'addressable'
  gem 'app_conf'
  gem 'appbundler', '= 0.11.2'
  gem 'artifactory'
  gem 'aws-sdk', '= 2.11.9'
  gem 'axiom-types'
  gem 'backports', '= 3.11.1'
  gem 'berkshelf'
  gem 'libyajl2'
end

# removing due to conflicts when running thor
# group :debug do
#   gem 'byebug'
# end

# to be tuned based on a future train/inspec release
group :inspec do
  gem 'inspec', '~> 2.1', '>= 2.1.78'
end
