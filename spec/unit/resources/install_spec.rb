# frozen_string_literal: true

require 'spec_helper'

describe 'tomcat_install' do
  step_into :tomcat_install
  platform 'ubuntu', '24.04'

  context 'with default properties' do
    recipe do
      tomcat_install 'default'
    end

    before do
      license_stat = instance_double(File::Stat, uid: 123)
      passwd = instance_double(Etc::Passwd, name: 'tomcat_default')

      allow(File).to receive(:stat).and_call_original
      allow(File).to receive(:stat).with('/opt/tomcat_default_9_0_117//LICENSE').and_return(license_stat)
      allow(Etc).to receive(:getpwuid).with(123).and_return(passwd)
    end

    it { is_expected.to install_package(%w(tar gzip)) }
    it { is_expected.to create_group('tomcat_default') }
    it { is_expected.to create_user('tomcat_default').with(gid: 'tomcat_default', shell: '/bin/false', system: true) }
    it { is_expected.to create_directory('tomcat install dir').with(path: '/opt/tomcat_default_9_0_117/', owner: 'tomcat_default', group: 'tomcat_default', mode: '0750') }
    it { is_expected.to create_remote_file('apache 9.0.117 tarball') }
    it { is_expected.to run_execute('extract tomcat tarball') }
    it { is_expected.to create_link('/opt/tomcat_default').with(to: '/opt/tomcat_default_9_0_117/') }
  end

  context 'with action :delete' do
    recipe do
      tomcat_install 'default' do
        action :delete
      end
    end

    it { is_expected.to delete_link('/opt/tomcat_default') }
    it { is_expected.to delete_directory('/opt/tomcat_default_9_0_117/').with(recursive: true) }
    it { is_expected.to delete_file("#{Chef::Config['file_cache_path']}/apache-tomcat-9.0.117.tar.gz") }
  end
end
