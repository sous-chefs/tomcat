# frozen_string_literal: true

title 'Default Tomcat Resource Tests'

control 'tomcat-install-01' do
  impact 1.0
  title 'Tomcat is installed from the upstream archive'

  describe directory('/opt/tomcat_default_9_0_117') do
    it { should exist }
    its('owner') { should eq 'tomcat_default' }
    its('group') { should eq 'tomcat_default' }
    its('mode') { should cmp '0750' }
  end

  describe file('/opt/tomcat_default') do
    it { should be_symlink }
    it { should be_linked_to '/opt/tomcat_default_9_0_117' }
  end
end

control 'tomcat-service-01' do
  impact 1.0
  title 'Tomcat is managed by systemd'

  describe systemd_service('tomcat_default') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/systemd/system/tomcat_default.service') do
    it { should exist }
    its('content') { should match(%r{ExecStart=/opt/tomcat_default/bin/catalina.sh start}) }
    its('content') { should match(/User=tomcat_default/) }
    its('content') { should match(/Group=tomcat_default/) }
  end

  describe port(8080) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end
