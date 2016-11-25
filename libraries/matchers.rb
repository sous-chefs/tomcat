#
# Cookbook:: tomcat
# Library:: matchers
#
# Author:: Tim Smith (<tsmith@chef.io>)
#
# Copyright:: 2016, Chef Software, Inc.
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

if defined?(ChefSpec)
  #################
  # tomcat_install
  #################
  ChefSpec.define_matcher :tomcat_install

  def install_tomcat_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_install, :install, resource_name)
  end

  ################
  # tomcat_service
  ################
  ChefSpec.define_matcher :tomcat_service

  def start_tomcat_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_service, :start, resource_name)
  end

  def enable_tomcat_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_service, :enable, resource_name)
  end

  def restart_tomcat_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_service, :restart, resource_name)
  end

  def stop_tomcat_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_service, :stop, resource_name)
  end

  def disable_tomcat_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:tomcat_service, :disable, resource_name)
  end
end
