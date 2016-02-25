provides :tomcat_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f < 15.04
end

property :instance_name, String, name_property: true
property :install_path, String
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' }
]

action :start do
  create_init
  create_service
end

action :stop do
  create_init
  s = create_service
  s.action :stop
end

action :disable do
  create_init
  s = create_service
  s.action :disable
end

action_class.class_eval do
  def create_init
    ensure_catalina_base

    template "/etc/init/tomcat_#{instance_name}.conf" do
      source 'init_upstart.erb'
      variables(
        instance: instance_name,
        env_vars: env_vars,
        install_path: derived_install_path
      )
      cookbook 'tomcat'
      owner 'root'
      group 'root'
      mode '0644'
    end
  end

  def create_service
    service "tomcat_#{instance_name}" do
      supports restart: true, status: true
      action [:start, :enable]
    end
  end
end
