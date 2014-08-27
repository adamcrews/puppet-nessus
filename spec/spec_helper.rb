require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-utils'

FIXTURES_PATH = File.expand_path(File.dirname(__FILE__) + '/fixtures')
# Set up our $LOAD_PATH to properly include custom provider code from modules
# in spec/fixtures
$LOAD_PATH.unshift(*Dir["#{FIXTURES_PATH}/modules/*/lib"])

Dir[File.absolute_path(File.dirname(__FILE__) + '/support/*.rb')].each do |f|
  require f
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.formatter = :documentation
  c.default_facts = PathDefender::CentOS.centos_facts.merge({:fqdn => 'pd.example.com'})
  c.hiera_config = File.join(FIXTURES_PATH, 'hiera.yaml')
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
