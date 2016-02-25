# make sure we have java installed
include_recipe 'java'

# Install Tomcat 8.0.32 to the default location
tomcat_install 'helloworld' do
  version '8.0.32'
end

# Drop off our own server.xml that uses a non-default port setup
cookbook_file '/opt/tomcat_helloworld/conf/server.xml' do
  source 'helloworld_server.xml'
  owner 'root'
  group 'root'
  mode '0644'
end

# start the helloworld tomcat service using a non-standard pic location
tomcat_service 'helloworld' do
  action :start
  env_vars [{ 'CATALINA_PID' => '/opt/tomcat_helloworld/bin/non_standard_location.pid' }]
end
