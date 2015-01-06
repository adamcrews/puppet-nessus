require 'spec_helper'

describe 'nessus::user' do

  context 'when ensure => present' do
    let(:title) { 'joebob' }
    let(:params) {{
      :password   => 'joebobpass',
      :ensure     => 'present',
      :user_base  => '/tmp/foo',
    }}

    it { should contain_nessus__user('joebob') }

    it { should contain_file("#{params[:user_base]}").with(
      :ensure => 'directory',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0600',
    )}

    it { should contain_file("#{params[:user_base]}/#{title}").with_ensure('directory') }
    it { should contain_file("#{params[:user_base]}/#{title}/auth").with_ensure('directory') }
    it { should contain_file("#{params[:user_base]}/#{title}/reports").with_ensure('directory') }

    it { should contain_file("#{params[:user_base]}/#{title}/auth/hash").with_ensure('absent') }
    it { should contain_file("#{params[:user_base]}/#{title}/auth/password").with(
      :ensure => 'file',
      :content => "#{params[:password]}\n",
    )}

    it { should contain_file("#{params[:user_base]}/#{title}/auth/rules").with_ensure('file') }

    context 'with admin => true' do
      let(:params) {{ 
        :password   => 'joebobpass',
        :ensure     => 'present',
        :user_base  => '/tmp/foo',
        :admin      => true 
      }}
      it { should contain_file("#{params[:user_base]}/#{title}/auth/admin").with_ensure('file') }
    end

    context 'with admin => false' do
      it { should contain_file("#{params[:user_base]}/#{title}/auth/admin").with_ensure('absent') }
    end

    context 'with admin invalid' do
      let(:params) {{ 
        :password   => 'joebobpass',
        :ensure     => 'present',
        :user_base  => '/tmp/foo',
        :admin      => 'Im a string!'
      }}
      it do
        should_not compile
        #expect{ should compile }.to raise_error(Puppet::Error)
      end
    end
  end

  context 'when ensure => absent' do
    let(:title) { 'joebob' }
    let(:params) {{
      :password   => 'joebobpass',
      :ensure     => 'absent',
      :user_base  => '/tmp/foo',
    }}

    it { should contain_file("#{params[:user_base]}/#{title}").with_ensure('absent') }
  end

  context 'when ensure => invalid' do
    let(:title) { 'joebob' }
    let(:params) {{
      :password   => 'joebobpass',
      :ensure     => 'invalid',
      :user_base  => '/tmp/foo',
    }}

    it do
      #expect{ should compile }.to raise_error(Puppet::Error)
      should_not compile
    end
  end
end

