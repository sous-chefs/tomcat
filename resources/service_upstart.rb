#
# Cookbook:: tomcat
# Resource:: service_upstart
#
# Copyright:: 2016-2019, Chef Software, Inc.
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

provides :tomcat_service_upstart

provides :tomcat_service, platform_family: 'debian' do |_node|
  Chef::Platform::ServiceHelpers.service_resource_providers.include?(:upstart) &&
    !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
end

property :instance_name, String, name_property: true
property :install_path, String
property :tomcat_user, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_group, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :service_name, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :env_vars, Array, default: [
  { 'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid' },
]

property :service_template_source, String, default: 'init_upstart.erb'
property :service_template_cookbook, String, default: 'tomcat'
property :service_template_local, [true, false], default: false

action :start do
  action_create

  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports restart: true, status: true
    action :start
  end
end

action :create do
  template "/etc/init/#{new_resource.service_name}.conf" do
    source new_resource.service_template_source
    sensitive new_resource.sensitive
    variables(
      user: new_resource.tomcat_user,
      group: new_resource.tomcat_group,
      instance: new_resource.instance_name,
      env_vars: envs_with_catalina_base,
      install_path: derived_install_path
    )
    cookbook new_resource.service_template_cookbook unless new_resource.service_template_local
    local new_resource.service_template_local
    owner 'root'
    group 'root'
    mode '0644'
  end
end

action :stop do
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :stop
    only_if { ::File.exist?("/etc/init/#{new_resource.service_name}.conf") }
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
  action_create

  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :enable
    only_if { ::File.exist?("/etc/init/#{new_resource.service_name}.conf") }
  end
end

action :disable do
  service new_resource.service_name do
    provider Chef::Provider::Service::Upstart
    supports status: true
    action :disable
    only_if { ::File.exist?("/etc/init/#{new_resource.service_name}.conf") }
  end
end

action_class do
  include ::TomcatCookbook::ServiceHelpers
end
