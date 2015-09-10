require 'spec_helper'

service_name = ''
package_name = ''
if host_inventory['platform'] == 'opensuse'
  service_name = 'tomcat'
  package_name = 'tomcat'
elsif host_inventory['platform'] == 'centos'
  service_name = 'tomcat7'
  package_name = 'tomcat7'
elsif host_inventory['platform'] == 'ubuntu'
  service_name = 'tomcat7'
  package_name = 'tomcat7'
end

describe package(package_name) do
  it { should be_installed }
end

describe service(service_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end
