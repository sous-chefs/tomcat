#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

tomcat_pkgs = value_for_platform(
  ["debian","ubuntu"] => {
    "default" => ["tomcat#{node["tomcat"]["base_version"]}","tomcat#{node["tomcat"]["base_version"]}-admin"]
  },
  ["centos","redhat","fedora","amazon"] => {
    "default" => ["tomcat#{node["tomcat"]["base_version"]}","tomcat#{node["tomcat"]["base_version"]}-admin-webapps"]
  },
  ["smartos"] => {
    "default" => ["apache-tomcat"]
  },
  "default" => ["tomcat#{node["tomcat"]["base_version"]}"]
)

tomcat_pkgs.each do |pkg|
  package pkg do
    action :install
    version node["tomcat"]["base_version"].to_s if platform_family?("smartos")
  end
end

directory node['tomcat']['endorsed_dir'] do
  mode "0755"
  recursive true
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

case node["platform"]
when "smartos"
  template "/opt/local/share/smf/apache-tomcat/manifest.xml" do
    source "manifest.xml.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :run, "execute[tomcat_manifest]"
  end
  execute "tomcat_manifest" do
    command "svccfg import /opt/local/share/smf/apache-tomcat/manifest.xml"
    action :nothing
    notifies :restart, "service[tomcat]"
  end
end

service "tomcat" do
  case node["platform"]
  when "centos","redhat","fedora","amazon"
    service_name "tomcat#{node["tomcat"]["base_version"]}"
    supports :restart => true, :status => true
  when "debian","ubuntu"
    service_name "tomcat#{node["tomcat"]["base_version"]}"
    supports :restart => true, :reload => false, :status => true
  when "smartos"
    service_name "tomcat"
    supports :restart => true, :reload => false, :status => true
  else
    service_name "tomcat#{node["tomcat"]["base_version"]}"
  end
  action [:enable, :start]
  retries 4
  retry_delay 30
end

node.set_unless['tomcat']['keystore_password'] = secure_password
node.set_unless['tomcat']['truststore_password'] = secure_password

unless node['tomcat']["truststore_file"].nil?
  java_options = node['tomcat']['java_options'].to_s
  java_options << " -Djavax.net.ssl.trustStore=#{node["tomcat"]["config_dir"]}/#{node["tomcat"]["truststore_file"]}"
  java_options << " -Djavax.net.ssl.trustStorePassword=#{node["tomcat"]["truststore_password"]}"

  node.set['tomcat']['java_options'] = java_options
end

case node["platform"]
when "centos","redhat","fedora","amazon"
  template "/etc/sysconfig/tomcat#{node["tomcat"]["base_version"]}" do
    source "sysconfig_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[tomcat]"
  end
when "smartos"
else
  template "/etc/default/tomcat#{node["tomcat"]["base_version"]}" do
    source "default_tomcat6.erb"
    owner "root"
    group "root"
    mode "0644"
    notifies :restart, "service[tomcat]"
  end
end

template "#{node["tomcat"]["config_dir"]}/server.xml" do
  source "server.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[tomcat]"
end

template "#{node["tomcat"]["config_dir"]}/logging.properties" do
  source "logging.properties.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[tomcat]"
end

unless node['tomcat']["ssl_cert_file"].nil?
  script "create_tomcat_keystore" do
    interpreter "bash"
    action :nothing
    cwd node['tomcat']['config_dir']
    code <<-EOH
      cat #{node['tomcat']['ssl_chain_files'].join(' ')} > cacerts.pem
      openssl pkcs12 -export \
       -inkey #{node['tomcat']['ssl_key_file']} \
       -in #{node['tomcat']['ssl_cert_file']} \
       -chain \
       -CAfile cacerts.pem \
       -password pass:#{node['tomcat']['keystore_password']} \
       -out #{node['tomcat']['keystore_file']}
    EOH
    notifies :restart, "service[tomcat]"
  end
  cookbook_file "#{node['tomcat']['config_dir']}/#{node['tomcat']['ssl_cert_file']}" do
    mode "0644"
    notifies :run, "script[create_tomcat_keystore]"
  end
  cookbook_file "#{node['tomcat']['config_dir']}/#{node['tomcat']['ssl_key_file']}" do
    mode "0644"
    notifies :run, "script[create_tomcat_keystore]"
  end
  node['tomcat']['ssl_chain_files'].each do |cert|
    cookbook_file "#{node['tomcat']['config_dir']}/#{cert}" do
      mode "0644"
      notifies :run, "script[create_tomcat_keystore]"
    end
  end
else
  execute "Create Tomcat SSL certificate" do
    group node['tomcat']['group']
    command "#{node['tomcat']['keytool']} -genkeypair -keystore \"#{node['tomcat']['config_dir']}/#{node['tomcat']['keystore_file']}\" -storepass \"#{node['tomcat']['keystore_password']}\" -keypass \"#{node['tomcat']['keystore_password']}\" -dname \"#{node['tomcat']['certificate_dn']}\""
    umask 0007
    creates "#{node['tomcat']['config_dir']}/#{node['tomcat']['keystore_file']}"
    action :run
    notifies :restart, "service[tomcat]"
  end
end

unless node['tomcat']["truststore_file"].nil?
  cookbook_file "#{node['tomcat']['config_dir']}/#{node['tomcat']['truststore_file']}" do
    mode "0644"
  end
end
