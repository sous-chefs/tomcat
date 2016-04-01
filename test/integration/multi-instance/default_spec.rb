describe file('/opt/tomcat_helloworld_8_0_32/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'tomcat_helloworld' }
end

describe file('/opt/special/tomcat_docs_7_0_42/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'tomcat_docs' }
end

describe command('curl http://localhost:8081/sample/') do
  its('stdout') { should match /Hello, World/ }
end

describe command('curl http://localhost:8080/') do
  its('stdout') { should match /successfully installed Tomcat/ }
end

%w(tomcat_helloworld tomcat_docs).each do |service_name|
  describe user(service_name) do
    it { should exist }
  end

  describe group(service_name) do
    it { should exist }
  end

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
