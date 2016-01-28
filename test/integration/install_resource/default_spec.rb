describe file('/opt/tomcat_helloworld_8_0_30/LICENSE') do
  it { should be_file }
  it { should be_owned_by 'tomcat_helloworld' }
end

describe user('tomcat_helloworld') do
  it { should exist }
end

describe group('tomcat_helloworld') do
  it { should exist }
end
