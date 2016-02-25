provides :tomcat_service, platform: 'fedora'

provides :tomcat_service, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f >= 7.0
end

provides :tomcat_service, platform: 'debian' do |node|
  node['platform_version'].to_i >= 8
end

provides :tomcat_service, platform: 'ubuntu' do |node|
  node['platform_version'].to_f >= 15.10
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

    template "/usr/lib/systemd/system/tomcat_#{instance_name}.service" do
      source 'init_systemd.erb'
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
