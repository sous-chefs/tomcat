require 'spec_helper'

service_name = 'tomcat6'
package_name = 'tomcat6'
config_dir = '/etc/tomcat'

if host_inventory['platform'] == 'opensuse'
  service_name = 'tomcat'
  package_name = 'tomcat'
elsif host_inventory['platform'] == 'redhat' # centos is also here
  service_name = 'tomcat6'
  package_name = 'tomcat6'
  config_dir = '/etc/tomcat6'
elsif host_inventory['platform'] == 'ubuntu'
  service_name = 'tomcat6'
  package_name = 'tomcat6'
  config_dir = '/etc/tomcat6'
elsif host_inventory['platform'] == 'debian'
  service_name = 'tomcat6'
  package_name = 'tomcat6'
end
puts "Platform: #{host_inventory['platform']}, Family: #{os['family']}"

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

describe file("#{config_dir}/tomcat-users.xml") do
  its(:content) do
    should match %r{<user username="testuser" password="testpass" roles="manager-script, admin" \/>}
  end
end
