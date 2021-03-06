require 'spec_helper'

describe 'selinux' do

  describe 'has correct selinux_config file attributes' do

    it {
      should contain_file('selinux_config').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    }
  end

  describe 'when using default values' do
    it {
      should contain_file('selinux_config').with({
        'path' => '/etc/selinux/config',
      })
      should contain_file('selinux_config').with_content(/^\s*SELINUX=disabled$/)
      should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=targeted$/)
    }
  end

  describe 'when setting mode parameter to enforcing' do
    let :params do
      { :mode => 'enforcing' }
    end

    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUX=enforcing$/)
    }
  end

  describe 'when setting mode parameter to permissive' do
    let :params do
      { :mode => 'permissive' }
    end

    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUX=permissive$/)
    }
  end

  describe 'when setting mode parameter to disabled' do
    let :params do
      { :mode => 'disabled' }
    end

    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUX=disabled$/)
    }
  end

  describe 'invalid mode parameter' do
    let :params do
      { :mode => 'INVALID' }
    end

    it {
      expect {
        should contain_file('selinux_config')
      }.to raise_error(Puppet::Error, /mode is INVALID and must be either 'enforcing', 'permissive' or 'disabled'./)
    }
  end

  describe 'when setting type parameter to strict' do
    let :params do
      { :type => 'strict' }
    end

    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=strict$/)
    }
  end

  describe 'when setting type parameter to targeted' do
    let :params do
      { :type => 'targeted' }
    end

    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=targeted$/)
    }
  end

  describe 'invalid type parameter' do
    let :params do
      { :type => 'INVALID' }
    end

    it {
      expect {
        should contain_file('selinux_config')
      }.to raise_error(Puppet::Error, /type is INVALID and must be either 'targeted' or 'strict'./)
    }
  end

  describe 'when setting both parameters to valid values' do
    let :params do
      {
        :mode => 'enforcing',
        :type => 'strict'
      }
    end
    it {
      should contain_file('selinux_config').with_content(/^\s*SELINUX=enforcing$/)
      should contain_file('selinux_config').with_content(/^\s*SELINUXTYPE=strict$/)
    }
  end

  describe 'when setting the file path' do
    let :params do
      { :config_file => '/etc/selinux.conf' }
    end

    it {
      should contain_file('selinux_config').with({
        'path' => '/etc/selinux.conf'
       })
    }
  end
end
