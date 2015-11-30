#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010-2015, Chef Software, Inc.
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

# required for the secure_password method from the openssl cookbook
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# RHEL systems prior to 7 need the EPEL repository setup
if node['tomcat']['base_version'].to_i == 7
  if platform_family?('rhel') && node['platform_version'].to_i < 7
    include_recipe 'yum-epel'
  end
end

package node['tomcat']['packages'] do
  action :install
end

package node['tomcat']['deploy_manager_packages'] do
  action :install
end

unless node['tomcat']['deploy_manager_apps']
  directory "#{node['tomcat']['webapp_dir']}/manager" do
    action :delete
    recursive true
  end
  file "#{node['tomcat']['config_dir']}/Catalina/localhost/manager.xml" do
    action :delete
  end
  directory "#{node['tomcat']['webapp_dir']}/host-manager" do
    action :delete
    recursive true
  end
  file "#{node['tomcat']['config_dir']}/Catalina/localhost/host-manager.xml" do
    action :delete
  end
end

node.set_unless['tomcat']['keystore_password'] = secure_password
node.set_unless['tomcat']['truststore_password'] = secure_password

def create_service(instance)
  service instance do
    case node['platform_family']
    when 'rhel', 'fedora'
      service_name instance
      supports restart: true, status: true
    when 'debian'
      service_name instance
      supports restart: true, reload: false, status: true
    when 'suse'
      service_name 'tomcat'
      supports restart: true, status: true
      init_command '/usr/sbin/rctomcat'
    when 'smartos'
      # SmartOS doesn't support multiple instances
      service_name 'tomcat'
      supports restart: false, reload: false, status: true
    else
      service_name instance
    end
    action [:start, :enable]
    notifies :run, "execute[wait for #{instance}]", :immediately
    retries 4
    retry_delay 30
  end
end

if node['tomcat']['run_base_instance']
  tomcat_instance 'base' do
    port node['tomcat']['port']
    proxy_port node['tomcat']['proxy_port']
    proxy_name node['tomcat']['proxy_name']
    secure node['tomcat']['secure']
    scheme node['tomcat']['scheme']
    ssl_port node['tomcat']['ssl_port']
    ssl_proxy_port node['tomcat']['ssl_proxy_port']
    ajp_port node['tomcat']['ajp_port']
    ajp_redirect_port node['tomcat']['ajp_redirect_port']
    shutdown_port node['tomcat']['shutdown_port']
  end
  instance = node['tomcat']['base_instance']
  create_service(instance)
end

node['tomcat']['instances'].each do |name, attrs|
  tomcat_instance name do
    port attrs['port']
    proxy_port attrs['proxy_port']
    proxy_name attrs['proxy_name']
    secure attrs['secure']
    scheme attrs['scheme']
    ssl_port attrs['ssl_port']
    ssl_proxy_port attrs['ssl_proxy_port']
    ajp_port attrs['ajp_port']
    ajp_redirect_port attrs['ajp_redirect_port']
    shutdown_port attrs['shutdown_port']
    config_dir attrs['config_dir']
    log_dir attrs['log_dir']
    work_dir attrs['work_dir']
    context_dir attrs['context_dir']
    webapp_dir attrs['webapp_dir']
    catalina_options attrs['catalina_options']
    java_options attrs['java_options']
    use_security_manager attrs['use_security_manager']
    authbind attrs['authbind']
    max_threads attrs['max_threads']
    ssl_max_threads attrs['ssl_max_threads']
    ssl_cert_file attrs['ssl_cert_file']
    ssl_key_file attrs['ssl_key_file']
    ssl_chain_files attrs['ssl_chain_files']
    keystore_file attrs['keystore_file']
    keystore_type attrs['keystore_type']
    truststore_file attrs['truststore_file']
    truststore_type attrs['truststore_type']
    certificate_dn attrs['certificate_dn']
    loglevel attrs['loglevel']
    tomcat_auth attrs['tomcat_auth']
    client_auth attrs['client_auth']
    user attrs['user']
    group attrs['group']
    home attrs['home']
    base attrs['base']
    tmp_dir attrs['tmp_dir']
    lib_dir attrs['lib_dir']
    endorsed_dir attrs['endorsed_dir']
    ajp_packetsize attrs['ajp_packetsize']
    uriencoding attrs['uriencoding']
  end

  instance = "#{node['tomcat']['base_instance']}-#{name}"
  create_service(instance)
end

execute "wait for #{instance}" do
  command 'sleep 5'
  action :nothing
end
