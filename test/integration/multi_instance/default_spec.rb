puts 'Sleeping to make sure the services are started'
sleep 10

describe file('/opt/tomcat_helloworld_8_0_43') do
  it { should be_directory }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
  its('mode') { should cmp '0750' }
end

# make sure we get our override env value and not both
describe file('/etc/init/tomcat_helloworld.conf') do
  its('content') { should match(%r{env CATALINA_BASE="/opt/tomcat_helloworld/"}) }
  its('content') { should_not match(%r{env CATALINA_BASE="/opt/tomcat_helloworld"}) }
end

describe file('/opt/tomcat_dirworld_8_0_43') do
  it { should be_directory }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
  its('mode') { should cmp '0755' }
end

describe file('/opt/tomcat_helloworld_8_0_43/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
end

describe file('/opt/tomcat_dirworld_8_0_43/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'cool_user' }
  its('group') { should eq 'cool_group' }
end

describe file('/opt/special/tomcat_docs_7_0_42') do
  it { should be_directory }
  it { should be_owned_by 'tomcat_docs' }
  its('group') { should eq 'tomcat_docs' }
  its('mode') { should cmp '0750' }
end

describe file('/opt/special/tomcat_docs_7_0_42/LICENSE') do
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

%w(cool_user tomcat_docs).each do |user_name|
  describe user(user_name) do
    it { should exist }
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
