provides :tomcat_service, platform: 'amazon'

provides :tomcat_service, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
  node['platform_version'].to_f <= 7.0
end

provides :tomcat_service, platform: 'suse'
provides :tomcat_service, platform: 'debian'
provides :tomcat_service, platform: 'ubuntu'

property :instance_name, String, name_property: true
property :path, String, default: nil
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' }
]

# the install path of this instance of tomcat
def install_path
  path ? path : "/opt/tomcat_#{instance_name}"
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

# make sure catalina base is in the env_var has no matter what
def ensure_catalina_base
  unless env_vars.any? { |env_hash| env_hash.key?('CATALINA_BASE') }
    env_vars.unshift('CATALINA_BASE' => install_path)
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

    template "#{install_path}/bin/setenv.sh" do
      source 'setenv.erb'
      mode '0755'
      cookbook 'tomcat'
      variables(
        env_vars: env_vars
      )
    end

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
