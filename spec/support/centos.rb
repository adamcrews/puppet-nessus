# common utilities for CentOS servers
#
require 'rspec/core/shared_context'

# we need a module to have a default shared_context, we can't use include_contest from RSpec.configure
module PathDefender
  module CentOS
    extend RSpec::Core::SharedContext

    def self.centos_facts
      {
          :ipaddress              => '192.168.1.1',
          :kernel                 => 'Linux',
          :operatingsystem        => 'CentOS',
          :operatingsystemrelease => '6.5',
          :osfamily               => 'RedHat',
          :architecture           => 'x86_64',
          :concat_basedir         => "/tmp/concat", # Until we can upgrade rspec-puppet and supply this via default_facts
      }
    end

    let(:centos_facts) {centos_facts}
    let(:facts) { centos_facts }
  end
end

shared_context :centos do
  extend PathDefender::CentOS
end

