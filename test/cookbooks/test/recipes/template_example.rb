include_recipe 'java'

instance_name = 'template'
service_name = "tomcat_#{instance_name}"

tomcat_install instance_name do
  version '9.0.34'
end

template "/opt/#{service_name}/conf/server.xml" do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    shutdown_port: 8007,
    http_port: 8082,
    https_port: 8445
  )
  notifies :restart, "tomcat_service[#{instance_name}]"
end

init_template = "my_init_#{node['init_package']}.erb"

tomcat_service instance_name do
  service_template_source init_template
  service_template_cookbook 'test'
end
