provides :tomcat_service
unified_mode true
default_action :create

property :instance_name, String, name_property: true
property :install_path, String
property :tomcat_user, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_group, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :service_name, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' },
]
property :service_vars, Array, default: []
property :unit_content, [Hash, String, nil], default: nil

action :create do
  systemd_unit unit_name do
    content new_resource.unit_content || tomcat_unit_content
    sensitive new_resource.sensitive
    action :create
  end
end

action :start do
  action_create

  systemd_unit unit_name do
    action :start
  end
end

action :stop do
  systemd_unit unit_name do
    action :stop
  end
end

action :restart do
  systemd_unit unit_name do
    action :restart
  end
end

action :enable do
  action_create

  systemd_unit unit_name do
    action :enable
  end
end

action :disable do
  systemd_unit unit_name do
    action :disable
  end
end

action :delete do
  systemd_unit unit_name do
    action [:stop, :disable, :delete]
  end
end

action_class do
  include ::TomcatCookbook::ServiceHelpers

  def unit_name
    "#{new_resource.service_name}.service"
  end

  def tomcat_unit_content
    {
      Unit: {
        Description: "#{new_resource.instance_name} Apache Tomcat Application",
        After: 'syslog.target network.target',
      },
      Service: service_content,
      Install: {
        WantedBy: 'multi-user.target',
      },
    }
  end

  def service_content
    {
      Type: 'forking',
      Environment: environment_entries,
      ExecStart: "#{derived_install_path}/bin/catalina.sh start",
      ExecStop: "#{derived_install_path}/bin/catalina.sh stop",
      SuccessExitStatus: '0 143',
      Restart: 'on-failure',
      RestartSec: 2,
      User: new_resource.tomcat_user,
      Group: new_resource.tomcat_group,
    }.merge(service_var_entries)
  end

  def environment_entries
    envs_with_catalina_base.flat_map do |env_hash|
      env_hash.map { |key, value| "#{key}=#{value}" }
    end
  end

  def service_var_entries
    new_resource.service_vars.each_with_object({}) do |entry, merged|
      entry.each { |key, value| merged[key.to_sym] = value }
    end
  end
end
