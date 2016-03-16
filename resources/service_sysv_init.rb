provides :tomcat_service, platform_family: 'suse'
provides :tomcat_service, platform: 'amazon'

provides :tomcat_service, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f < 7.0
end

provides :tomcat_service, platform: 'debian' do |node|
  node['platform_version'].to_i < 8
end

property :instance_name, String, name_property: true
property :install_path, String
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' }
]

action :start do
  create_init

  service "tomcat_#{new_resource.instance_name}" do
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "tomcat_#{new_resource.instance_name}" do
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action :restart do
  action_stop
  action_start
end

action :enable do
  service "tomcat_#{instance_name}" do
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action :disable do
  service "tomcat_#{new_resource.instance_name}" do
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action_class.class_eval do
  def create_init
    # set the CATALINA_BASE value unless the user has passed it
    ensure_catalina_base

    # define the lock dir for RHEL vs. debian
    platform_lock_dir = value_for_platform_family(
      %w(rhel fedora suse) => '/var/lock/subsys',
      'debian' => '/var/lock',
      'default' => '/var/lock'
    )

    # the init script will not run without redhat-lsb packages
    if platform_family?('rhel')
      if node['platform_version'].to_i < 6.0
        package 'redhat-lsb'
      else
        package 'redhat-lsb-core'
      end
    end

    template "#{derived_install_path}/bin/setenv.sh" do
      source 'setenv.erb'
      mode '0755'
      cookbook 'tomcat'
      variables(
        env_vars: new_resource.env_vars
      )
    end

    template "/etc/init.d/tomcat_#{new_resource.instance_name}" do
      mode '0755'
      source 'init_sysv.erb'
      cookbook 'tomcat'
      variables(
        lock_dir: platform_lock_dir,
        install_path: derived_install_path
      )
    end
  end
end
