#
# Cookbook Name:: jetty
# Attributes:: default
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

default["tomcat"]["port"] = 8080
default["tomcat"]["ssl_port"] = 8443
default["tomcat"]["ajp_port"] = 8009
default["tomcat"]["java_options"] = "-Xmx128M -Djava.awt.headless=true"
default["tomcat"]["use_security_manager"] = false
default["tomcat"]["authbind"] = "no"

case platform
when "centos","redhat","fedora"
  default["tomcat"]["user"] = "tomcat"
  default["tomcat"]["group"] = "tomcat"
  default["tomcat"]["home"] = "/usr/share/tomcat6"
  default["tomcat"]["base"] = "/usr/share/tomcat6"
  default["tomcat"]["config_dir"] = "/etc/tomcat6"
  default["tomcat"]["log_dir"] = "/var/log/tomcat6"
  default["tomcat"]["tmp_dir"] = "/var/cache/tomcat6/temp"
  default["tomcat"]["work_dir"] = "/var/cache/tomcat6/work"
  default["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  default["tomcat"]["webapp_dir"] = "/var/lib/tomcat6/webapps"
when "debian","ubuntu"
  default["tomcat"]["user"] = "tomcat6"
  default["tomcat"]["group"] = "tomcat6"
  default["tomcat"]["home"] = "/usr/share/tomcat6"
  default["tomcat"]["base"] = "/var/lib/tomcat6"
  default["tomcat"]["config_dir"] = "/etc/tomcat6"
  default["tomcat"]["log_dir"] = "/var/log/tomcat6"
  default["tomcat"]["tmp_dir"] = "/tmp/tomcat6-tmp"
  default["tomcat"]["work_dir"] = "/var/cache/tomcat6"
  default["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  default["tomcat"]["webapp_dir"] = "/var/lib/tomcat6/webapps"
else
  default["tomcat"]["user"] = "tomcat6"
  default["tomcat"]["group"] = "tomcat6"
  default["tomcat"]["home"] = "/usr/share/tomcat6"
  default["tomcat"]["base"] = "/var/lib/tomcat6"
  default["tomcat"]["config_dir"] = "/etc/tomcat6"
  default["tomcat"]["log_dir"] = "/var/log/tomcat6"
  default["tomcat"]["tmp_dir"] = "/tmp/tomcat6-tmp"
  default["tomcat"]["work_dir"] = "/var/cache/tomcat6"
  default["tomcat"]["context_dir"] = "#{tomcat["config_dir"]}/Catalina/localhost"
  default["tomcat"]["webapp_dir"] = "/var/lib/tomcat6/webapps"
end
