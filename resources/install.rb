#
# Cookbook:: tomcat
# Resource:: install
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

include TomcatCookbook::InstallHelpers

property :instance_name, String, name_property: true
property :version, String, default: '8.5.54', regex: /^\d+.\d+.\d+$/
property :version_archive, String, default: lazy { tomcat_archive_name(version) }
property :install_path, String, default: lazy { default_tomcat_install_path(instance_name, version) }
property :tarball_base_uri, String, default: 'http://archive.apache.org/dist/tomcat/', desired_state: false
property :checksum_base_uri, String, default: 'http://archive.apache.org/dist/tomcat/', desired_state: false
property :verify_checksum, [true, false], default: true, desired_state: false
property :dir_mode, String, default: '0750'
property :exclude_docs, [true, false], default: true, desired_state: false
property :exclude_examples, [true, false], default: true, desired_state: false
property :exclude_manager, [true, false], default: false, desired_state: false
property :exclude_hostmanager, [true, false], default: false, desired_state: false
property :tarball_uri, String, default: lazy { default_tomcat_archive_uri(tarball_base_uri, version, version_archive) }, desired_state: false
property :checksum_uri, String, default: lazy { default_tomcat_checksum_uri(checksum_base_uri, version, version_archive) }, desired_state: false
property :tarball_path, String, default: lazy { |r| "#{Chef::Config['file_cache_path']}/#{r.version_archive}" }, desired_state: false
property :tarball_validate_ssl, [true, false], default: true, desired_state: false
property :tomcat_user, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_group, String, default: lazy { |r| "tomcat_#{r.instance_name}" }
property :tomcat_user_shell, String, default: '/bin/false'
property :create_user, [true, false], default: true, desired_state: false
property :create_group, [true, false], default: true, desired_state: false
property :create_symlink, [true, false], default: true, desired_state: false
property :symlink_path, String, default: lazy { default_tomcat_symlink_path(instance_name) }, desired_state: false

action :install do
  # Support file:// uri moniker but short-circuit into a better pattern.
  new_resource.tarball_path = new_resource.tarball_uri.sub(%r{^file://}, '') if new_resource.tarball_uri.start_with?('file://')

  # some RHEL systems lack tar in their minimal install
  package %w(tar gzip)

  group new_resource.tomcat_group do
    action :create
    append true
    only_if { new_resource.create_group }
  end

  user new_resource.tomcat_user do
    gid new_resource.tomcat_group
    shell new_resource.tomcat_user_shell
    system true
    action :create
    only_if { new_resource.create_user }
  end

  directory 'tomcat install dir' do
    mode new_resource.dir_mode.to_s
    path new_resource.install_path
    recursive true
    owner new_resource.tomcat_user
    group new_resource.tomcat_group
  end

  remote_file "apache #{new_resource.version} tarball" do
    source new_resource.tarball_uri
    path new_resource.tarball_path
    verify { |file| validate_tomcat_checksum(file, new_resource.version, new_resource.checksum_uri, new_resource.tarball_validate_ssl) } if new_resource.verify_checksum
    # If a file already exists at the path specified, and we skip checksum verification, then we can assume that the file was laid down by the user.
    not_if { ::File.exist?(new_resource.tarball_path) } unless new_resource.verify_checksum
  end

  execute 'extract tomcat tarball' do
    command extraction_command
    action :run
    creates ::File.join(new_resource.install_path, 'LICENSE')
  end

  # make sure the instance's user owns the instance install dir
  execute "chown #{new_resource.install_path} as #{new_resource.tomcat_user}" do
    command "chown -R #{new_resource.tomcat_user}:#{new_resource.tomcat_group} #{new_resource.install_path}"
    action :run
    not_if { Etc.getpwuid(::File.stat("#{new_resource.install_path}/LICENSE").uid).name == new_resource.tomcat_user }
  end

  # create a link that points to the latest version of the instance
  link new_resource.symlink_path.to_s do
    to new_resource.install_path
    only_if { new_resource.create_symlink }
  end
end

action_class do
  # build the extraction command based on the passed properties
  def extraction_command
    cmd = "tar -xzf #{new_resource.tarball_path} -C #{new_resource.install_path} --strip-components=1"
    cmd << " --exclude='*webapps/examples*'" if new_resource.exclude_examples
    cmd << " --exclude='*webapps/ROOT*'" if new_resource.exclude_examples
    cmd << " --exclude='*webapps/docs*'" if new_resource.exclude_docs
    cmd << " --exclude='*webapps/manager*'" if new_resource.exclude_manager
    cmd << " --exclude='*webapps/host-manager*'" if new_resource.exclude_hostmanager
    cmd
  end
end

# retain backwards compatibility with the old property name
alias_method :sha1_base_path, :checksum_base_uri

# Semantically, these are uris, not paths.
alias_method :tarball_base_path, :tarball_base_uri
alias_method :checksum_base_path, :checksum_base_uri
