require 'spec_helper'

describe 'nessus' do
  ['RedHat'].each do |system|
  
    let(:facts) {{ :osfamily => system }}

    it { should contain_anchor('nessus::begin') }
    it { should contain_class('nessus::params') }
    it { should contain_class('nessus::install') }
    it { should contain_class('nessus::config') }
    it { should contain_class('nessus::service') }
    it { should contain_anchor('nessus::end') }

    describe "nessus::install on #{system}" do
      let(:params) {{ 
        :package_ensure => 'present', 
        :package_name   => 'nessus', 
      }}

      it { should contain_package('nessus').with_ensure('present') }

      describe 'should allow package ensure to be overridden' do
        let(:params) {{ 
          :package_ensure => 'latest', 
          :package_name   => 'nessus' 
        }}

        it { should contain_package('nessus').with_ensure('latest') }
      end

      describe 'should allow the package name to be overriden' do
        let(:params) {{ 
          :package_ensure => 'present', 
          :package_name => 'wat' 
        }}

        it { should contain_package('nessus').with(
          :ensure => 'present',
          :name   => 'wat',
        )}
      end
    end

    describe 'nessus::config' do
      context 'without nessus_activation_code or supplied activation_code' do
        it { should compile }
      end

      context 'without nessus_activation_code and with supplied activation_code' do
        let(:params) {{
          :activation_code => 'xxxx-xxxx-xxxx-xxxx'
        }}

        it { should contain_exec('Activate Nessus').with(
          :command => "nessus-fetch --register #{params[:activation_code]}"
        )}

        it { should contain_exec('Wait 60 seconds for Nessus activation').with(
          :command      => 'sleep 60',
          :refreshonly  => true,
          :notify       => 'Service[nessusd]',
        ).that_subscribes_to('Exec[Activate Nessus]')
        }
      end

      context 'with nessus_activation_code' do
        let(:facts) {{
          :nessus_activation_code => 'yyyy-yyyy-yyyy-yyyy'
        }}

        it { should_not contain_exec('Activate Nessus') }
      end

      context 'with security_center' do
        let(:params) {{
          :security_center => true
        }}

        it { should contain_exec('Activate Nessus').with(
          :command => "nessus-fetch --security-center && touch /opt/nessus/var/nessus/security_center_activated"
        )}

        it { should contain_exec('Wait 60 seconds for Nessus activation').with(
          :command      => 'sleep 60',
          :refreshonly  => true,
          :notify       => 'Service[nessusd]',
        ).that_subscribes_to('Exec[Activate Nessus]')
        }
      end
    end

    describe 'nessus::service' do
      let(:params) {{
        :service_name   => 'nessusd',
        :service_ensure => 'running',
        :service_enable => true,
        :service_manage => true,
      }}

      describe 'with defaults' do
        it { should contain_service('nessus').with(
          :name   => 'nessusd',
          :enable => true,
          :ensure => 'running',
        )}
      end

      describe 'service_ensure' do
        describe 'when overriden' do
          let(:params) {{ :service_name => 'nessus', :service_ensure => 'stopped' }}
          it { should contain_service('nessus').with_ensure('stopped') }
        end
      end

      describe 'service_manage' do
        let(:params) {{
          :service_manage => false,
          :service_enable => true,
          :service_ensure => 'running',
          :service_name   => 'nessusd',
        }}

        it 'when set to false' do
          should_not contain_service('nessus').with({
            :enable => true,
            :ensure => 'running',
            :name   => 'nessus',
          })
        end
      end
    end
  end
end
