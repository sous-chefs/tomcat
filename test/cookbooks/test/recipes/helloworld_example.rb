# make sure we have java installed
include_recipe 'java'

user 'chefed'

# put chefed in the group so we can make sure we don't remove it by managing cool_group
group 'cool_group' do
  members 'chefed'
  action :create
end

# Install Tomcat 8.5.54 to the default location
tomcat_install 'helloworld' do
  version '8.5.54'
  tarball_uri 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.54/bin/apache-tomcat-8.5.54.tar.gz'
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
  source 'https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war'
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
