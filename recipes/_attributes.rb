#
# Cookbook Name:: tomcat
# Recipe:: _attributes
#
# Author:: Andrew Brown (<anbrown@blackberry.com>)
#
# Copyright 2013, BlackBerry, Inc.
#
#

# We set the attributes in here instead of attributes/default.rb, so they
# can be overridden by wrapper cookbooks, enabling use of the Berkshelf Way.

case node['platform']
when "centos","redhat","fedora","amazon"
  node.default["tomcat"]["user"] = "tomcat"
  node.default["tomcat"]["group"] = "tomcat"
  node.default["tomcat"]["home"] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["base"] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["config_dir"] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["log_dir"] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["tmp_dir"] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}/temp"
  node.default["tomcat"]["work_dir"] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}/work"
  node.default["tomcat"]["context_dir"] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
  node.default["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
  node.default["tomcat"]["keytool"] = "/usr/lib/jvm/java/bin/keytool"
  node.default["tomcat"]["lib_dir"] = "#{node["tomcat"]["home"]}/lib"
  node.default["tomcat"]["endorsed_dir"] = "#{node["tomcat"]["lib_dir"]}/endorsed"
when "debian","ubuntu"
  node.default["tomcat"]["user"] = "tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["group"] = "tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["home"] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["base"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["config_dir"] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["log_dir"] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["tmp_dir"] = "/tmp/tomcat#{node["tomcat"]["base_version"]}-tmp"
  node.default["tomcat"]["work_dir"] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["context_dir"] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
  node.default["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
  node.default["tomcat"]["keytool"] = "/usr/lib/jvm/default-java/bin/keytool"
  node.default["tomcat"]["lib_dir"] = "#{node["tomcat"]["home"]}/lib"
  node.default["tomcat"]["endorsed_dir"] = "#{node["tomcat"]["lib_dir"]}/endorsed"
when "smartos"
  node.default["tomcat"]["user"] = "tomcat"
  node.default["tomcat"]["group"] = "tomcat"
  node.default["tomcat"]["home"] = "/opt/local/share/tomcat"
  node.default["tomcat"]["base"] = "/opt/local/share/tomcat"
  node.default["tomcat"]["config_dir"] = "/opt/local/share/tomcat/conf"
  node.default["tomcat"]["log_dir"] = "/opt/local/share/tomcat/logs"
  node.default["tomcat"]["tmp_dir"] = "/opt/local/share/tomcat/temp"
  node.default["tomcat"]["work_dir"] = "/opt/local/share/tomcat/work"
  node.default["tomcat"]["context_dir"] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
  node.default["tomcat"]["webapp_dir"] = "/opt/local/share/tomcat/webapps"
  node.default["tomcat"]["keytool"] = "/opt/local/bin/keytool"
  node.default["tomcat"]["lib_dir"] = "#{node["tomcat"]["home"]}/lib"
  node.default["tomcat"]["endorsed_dir"] = "#{node["tomcat"]["home"]}/lib/endorsed"
else
  node.default["tomcat"]["user"] = "tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["group"] = "tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["home"] = "/usr/share/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["base"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["config_dir"] = "/etc/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["log_dir"] = "/var/log/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["tmp_dir"] = "/tmp/tomcat#{node["tomcat"]["base_version"]}-tmp"
  node.default["tomcat"]["work_dir"] = "/var/cache/tomcat#{node["tomcat"]["base_version"]}"
  node.default["tomcat"]["context_dir"] = "#{node["tomcat"]["config_dir"]}/Catalina/localhost"
  node.default["tomcat"]["webapp_dir"] = "/var/lib/tomcat#{node["tomcat"]["base_version"]}/webapps"
  node.default["tomcat"]["keytool"] = "keytool"
  node.default["tomcat"]["lib_dir"] = "#{node["tomcat"]["home"]}/lib"
  node.default["tomcat"]["endorsed_dir"] = "#{node["tomcat"]["lib_dir"]}/endorsed"
end
