#
# Cookbook:: tomcat
# Resource:: service_sysvinit
#
# Copyright:: 2016-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :tomcat_service_sysvinit
provides :tomcat_service, os: 'linux'

property :instance_name, String, name_property: true
property :install_path, String
property :tomcat_user, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_group, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' },
]

action :start do
  create_init

  service "tomcat_#{new_resource.instance_name}" do
    provider platform_sysv_init_class
    supports restart: true, status: true
    action :start
  end
end

action :stop do
  service "tomcat_#{new_resource.instance_name}" do
    provider platform_sysv_init_class
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action :restart do
  service "tomcat_#{new_resource.instance_name}" do
    provider platform_sysv_init_class
    supports status: true
    action :restart
  end
end

action :enable do
  create_init

  service "tomcat_#{new_resource.instance_name}" do
    provider platform_sysv_init_class
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action :disable do
  service "tomcat_#{new_resource.instance_name}" do
    provider platform_sysv_init_class
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init.d/tomcat_#{new_resource.instance_name}") }
  end
end

action_class.class_eval do
  include ::TomcatCookbook::ServiceHelpers

  def create_init
    # suse is missing libraries we need for sys-v
    package 'perl-Getopt-Long-Descriptive' if platform_family?('suse')

    # define the lock dir for RHEL vs. debian
    platform_lock_dir = value_for_platform_family(
      %w(rhel fedora suse) => '/var/lock/subsys',
      'debian' => '/var/lock',
      'default' => '/var/lock'
    )

    # the init script will not run without redhat-lsb packages
    if platform_family?('rhel', 'fedora')
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
      sensitive new_resource.sensitive
      notifies :restart, "service[tomcat_#{new_resource.instance_name}]"
      variables(
        env_vars: envs_with_catalina_base
      )
    end

    template "/etc/init.d/tomcat_#{new_resource.instance_name}" do
      mode '0755'
      source 'init_sysv.erb'
      cookbook 'tomcat'
      variables(
        user: new_resource.tomcat_user,
        group: new_resource.tomcat_group,
        lock_dir: platform_lock_dir,
        install_path: derived_install_path,
        instance_name: new_resource.instance_name
      )
    end
  end
end
