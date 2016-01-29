property :instance_name, String, name_property: true

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

    template "/etc/init.d/tomcat_#{instance_name}" do
      mode '0755'
      source 'init_script.erb'
      cookbook 'tomcat'
      variables(
        lock_dir: platform_lock_dir
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
