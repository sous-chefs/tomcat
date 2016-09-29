
provides :tomcat_service_upstart

provides :tomcat_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f < 15.10
end

property :instance_name, String, name_property: true
property :install_path, String
property :tomcat_user, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_group, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
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
  # do a stop and then start because the restart action in Upstart
  # doesn't actually reload the upstart service definition, which we
  # need since we shove config-ish things in there
  action_stop
  action_start
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
        user: new_resource.tomcat_user,
        group: new_resource.tomcat_group,
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
