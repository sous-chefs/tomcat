
provides :tomcat_service_upstart

provides :tomcat_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f < 15.10
end

property :instance_name, String, name_property: true
property :install_path, String
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' }
]
property :sensitive, kind_of: [TrueClass, FalseClass], default: false

action :start do
  create_init

  service "tomcat_#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Upstart
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "tomcat_#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init/tomcat_#{new_resource.instance_name}.conf") }
  end
end

action :restart do
  service "tomcat_#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Upstart
    supports restart: true, status: true
    action :restart
  end
end

action :enable do
  create_init

  service "tomcat_#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init/tomcat_#{new_resource.instance_name}.conf") }
  end
end

action :disable do
  service "tomcat_#{new_resource.instance_name}" do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init/tomcat_#{new_resource.instance_name}.conf") }
  end
end

action_class.class_eval do
  def create_init
    ensure_catalina_base

    template "/etc/init/tomcat_#{new_resource.instance_name}.conf" do
      source 'init_upstart.erb'
      sensitive new_resource.sensitive
      notifies :restart, "service[tomcat_#{new_resource.instance_name}]"
      variables(
        instance: new_resource.instance_name,
        env_vars: new_resource.env_vars,
        install_path: derived_install_path
      )
      cookbook 'tomcat'
      owner 'root'
      group 'root'
      mode '0644'
    end
  end
end
