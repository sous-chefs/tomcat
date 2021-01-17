puts 'Sleeping to make sure the services are started'
sleep 10

version_10 = attribute('tomcat_version_10').tr('.', '_')
version_8_5 = attribute('tomcat_version_8_5').tr('.', '_')
version_7 = attribute('tomcat_version_7').tr('.', '_')

describe file('/opt/tomcat_symworld_custom') do
  it { should be_symlink }
  it { should be_linked_to "/opt/tomcat_symworld_#{version_8_5}" }
end

describe file('/opt/tomcat_helloworld') do
  it { should be_symlink }
  it { should be_linked_to "/opt/tomcat_helloworld_#{version_10}" }
end

describe file("/opt/tomcat_helloworld_#{version_10}") do
  it { should be_directory }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
  its('mode') { should cmp '0750' }
end

# make sure we get our override env value and not both
if file('/etc/init/tomcat_helloworld.conf').exist?
  describe file('/etc/init/tomcat_helloworld.conf') do
    its('content') { should match(%r{env CATALINA_BASE="/opt/tomcat_helloworld/"}) }
    its('content') { should_not match(%r{env CATALINA_BASE="/opt/tomcat_helloworld"}) }
  end
end

describe file('/opt/tomcat_dirworld') do
  it { should_not exist }
end

describe file("/opt/tomcat_dirworld_#{version_8_5}") do
  it { should be_directory }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
  its('mode') { should cmp '0755' }
end

describe file("/opt/tomcat_helloworld_#{version_10}/LICENSE") do
  it { should be_file }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
end

describe file("/opt/tomcat_dirworld_#{version_8_5}/LICENSE") do
  it { should be_file }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
end

describe file("/opt/special/tomcat_docs_#{version_7}") do
  it { should be_directory }
  it { should be_owned_by 'tomcat_docs' }
  its('group') { should eq 'tomcat_docs' }
  its('mode') { should cmp '0750' }
end

describe file("/opt/special/tomcat_docs_#{version_7}/LICENSE") do
  it { should be_file }
  it { should be_owned_by 'tomcat_docs' }
  its('group') { should eq 'tomcat_docs' }
end

describe command('curl http://localhost:8081/sample/') do
  its('stdout') { should match(/Hello, World/) }
end

describe command('curl http://localhost:8080/') do
  its('stdout') { should match(/successfully installed Tomcat/) }
end

describe command('curl http://localhost:8082/sample/') do
  its('stdout') { should match(/Hello, World/) }
end

%w(cool_user tomcat_docs).each do |user_name|
  describe user(user_name) do
    it { should exist }
    its('shell') { should eq '/bin/false' }
  end
end

%w(cool_group tomcat_docs).each do |group_name|
  describe group(group_name) do
    it { should exist }
  end
end

describe etc_group.where(name: 'cool_group') do
  its('users') { should include 'chefed' }
end

# inspec tries to check the service status using systemd
# we need to manually check the process exists
describe command('ps ax | grep tomcat_doc[s]') do
  its('exit_status') { should eq 0 }
end

describe service('tomcat_helloworld') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('tomcat_my_custom_service_name') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('tomcat_dirworld') do
  it { should be_installed }
  it { should be_enabled }
  it { should_not be_running }
end
