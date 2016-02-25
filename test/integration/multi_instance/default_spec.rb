describe file('/opt/tomcat_helloworld_8_0_32/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'tomcat_helloworld' }
end

describe file('/opt/special/tomcat_docs_8_0_32/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'tomcat_docs' }
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
