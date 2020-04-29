include_recipe 'java'

instance_name = 'template'
service_name = "tomcat_#{instance_name}"

tomcat_install instance_name do
  version '9.0.34'
end

cookbook_file "/opt/#{service_name}/conf/server.xml" do
  source "#{instance_name}_server.xml"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, "tomcat_service_systemd[#{instance_name}]"
end

tomcat_service_systemd instance_name do
  action [:start, :enable]
  service_template_source 'my_init_systemd.erb'
  service_template_cookbook 'test'
end
