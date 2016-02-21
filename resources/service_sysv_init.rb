provides :tomcat_service, platform: 'amazon'

provides :tomcat_service, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f <= 7.0
end

provides :tomcat_service, platform: 'suse'
provides :tomcat_service, platform: 'debian'
provides :tomcat_service, platform: 'ubuntu'

property :instance_name, String, name_property: true
property :path, String, default: nil

# the install path of this instance of tomcat
def install_path
  path ? path : "/opt/tomcat_#{instance_name}/"
end

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
    platform_lock_dir = value_for_platform_family(
      %w(rhel fedora suse) => '/var/lock/subsys',
      'debian' => '/var/lock',
      'default' => '/var/lock'
    )

    # the init script will not run without lsb-core
    package 'redhat-lsb-core' if platform_family?('rhel')

    template "/etc/init.d/tomcat_#{instance_name}" do
      mode '0755'
      source 'init_sysv.erb'
      cookbook 'tomcat'
      variables(
        lock_dir: platform_lock_dir,
        install_path: install_path
      )
    end
  end

  def create_service
    service "tomcat_#{instance_name}" do
      supports restart: true, status: true
      action [:start, :enable]
    end
  end
end
