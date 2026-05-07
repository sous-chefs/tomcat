apt_update 'update' if platform_family?('debian')

include_recipe 'test::install_java'

directory '/var/cache/tomcat' do
  owner 'root'
  group 'root'
  mode '0755'
end

tomcat_install 'default' do
  version '9.0.117'
  tarball_path '/var/cache/tomcat/apache-tomcat-9.0.117.tar.gz'
end

template '/opt/tomcat_default/conf/server.xml' do
  source 'server.xml.erb'
  owner 'tomcat_default'
  group 'tomcat_default'
  mode '0644'
  variables(
    shutdown_port: 8005,
    http_port: 8080,
    https_port: 8443
  )
  notifies :restart, 'tomcat_service[default]'
end

tomcat_service 'default' do
  action [:enable, :start]
end
