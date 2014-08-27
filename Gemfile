source ENV['GEM_SOURCE'] || "https://rubygems.org"
rspecversion = ENV.key?('RSPEC_VERSION') ? "= #{ENV['RSPEC_VERSION']}" : ['>= 2.9 ', '< 3.0.0']

gem 'rake'
gem 'rspec', rspecversion
gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
gem 'rspec-puppet-utils'
gem 'parallel_tests'
gem 'puppet-lint'

gem 'puppetlabs_spec_helper'

#gem 'pry'
#gem 'serverspec'

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion
else
  gem 'facter', '< 2.0.0'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion
else
  gem 'puppet', '~> 3.6.0'
end

# vim:ft=ruby
