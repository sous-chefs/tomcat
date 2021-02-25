# make sure we have java installed
include_recipe 'java'

user 'chefed'

# put chefed in the group so we can make sure we don't remove it by managing cool_group
group 'cool_group' do
  members 'chefed'
  action :create
end

remote_file "#{Chef::Config['file_cache_path']}/apache-tomcat-10.0.0.tar.gz" do
  source 'http://archive.apache.org/dist/tomcat/tomcat-10/v10.0.0/bin/apache-tomcat-10.0.0.tar.gz'
  action :create
end

remote_file "#{Chef::Config['file_cache_path']}/apache-tomcat-10.0.0.tar.gz.sha512" do
  source 'http://archive.apache.org/dist/tomcat/tomcat-10/v10.0.0/bin/apache-tomcat-10.0.0.tar.gz.sha512'
  action :create
end

# Install Tomcat 8.5.54 to the default location
tomcat_install 'helloworld' do
  version '10.0.0'
  tarball_uri "file://#{Chef::Config['file_cache_path']}/apache-tomcat-10.0.0.tar.gz"
  checksum_uri "file://#{Chef::Config['file_cache_path']}/apache-tomcat-10.0.0.tar.gz.sha512"
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
end

# Install Tomcat 8.5.54 to the default location mode 0755
tomcat_install 'dirworld' do
  version '8.5.54'
  dir_mode '0755'
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.54/bin/apache-tomcat-8.5.54.tar.gz'
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
  create_symlink false
end

# Install Tomcat 8.5.54 to a custom symlink path
tomcat_install 'symworld' do
  version '8.5.54'
  dir_mode '0755'
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.54/bin/apache-tomcat-8.5.54.tar.gz'
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
  symlink_path '/opt/tomcat_symworld_custom'
end

# Drop off our own server.xml that uses a non-default port setup
template '/opt/tomcat_helloworld/conf/server.xml' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    shutdown_port: 8006,
    http_port: 8081,
    https_port: 8444
  )
  notifies :restart, 'tomcat_service[helloworld]'
end

remote_file '/opt/tomcat_helloworld/webapps/sample.war' do
  owner 'cool_user'
  mode '0644'
  source 'https://tomcat.apache.org/tomcat-10.0-doc/appdev/sample/sample.war'
  checksum '89b33caa5bf4cfd235f060c396cb1a5acb2734a1366db325676f48c5f5ed92e5'
end

# start the helloworld tomcat service using a non-standard pic location
tomcat_service 'helloworld' do
  action [:start, :enable]
  env_vars [{ 'CATALINA_BASE' => '/opt/tomcat_helloworld/' }, { 'CATALINA_PID' => '/opt/tomcat_helloworld/bin/non_standard_location.pid' }, { 'SOMETHING' => 'some_value' }]
  sensitive true
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
end

template '/opt/tomcat_symworld_custom/conf/server.xml' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    shutdown_port: 8007,
    http_port: 8082,
    https_port: 8445
  )
  notifies :restart, 'tomcat_service[symworld]'
end

remote_file '/opt/tomcat_symworld_custom/webapps/sample.war' do
  owner 'cool_user'
  mode '0644'
  source 'https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war'
  checksum '89b33caa5bf4cfd235f060c396cb1a5acb2734a1366db325676f48c5f5ed92e5'
end

cookbook_file "#{Chef::Config['file_cache_path']}/my_custom_systemd.erb" do
  source 'my_custom_systemd.erb'
  owner 'cool_user'
  group 'cool_group'
  mode '0755'
  action :create
end

# Create a service with a custom service name, and sourcing the service_template from a local file path
tomcat_service 'symworld' do
  action [:start, :enable]
  install_path '/opt/tomcat_symworld_custom'
  env_vars [{ 'CATALINA_BASE' => '/opt/tomcat_symworld_custom' }]
  sensitive true
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
  service_name 'tomcat_my_custom_service_name'
  service_template_source "#{Chef::Config['file_cache_path']}/my_custom_systemd.erb"
  service_template_local true
end

template '/opt/tomcat_dirworld_8_5_54/conf/server.xml' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    shutdown_port: 8008,
    http_port: 8083,
    https_port: 8446
  )
end

# Create a service that is created/enabled, but not started
tomcat_service 'dirworld' do
  action [:create, :enable]
  install_path '/opt/tomcat_dirworld_8_5_54'
  env_vars [{ 'CATALINA_BASE' => '/opt/tomcat_dirworld' }]
  sensitive true
  tomcat_user 'cool_user'
  tomcat_group 'cool_group'
end
