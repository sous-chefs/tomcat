# tomcat Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/tomcat.svg?branch=master)](https://travis-ci.org/chef-cookbooks/tomcat) [![Cookbook Version](https://img.shields.io/cookbook/v/tomcat.svg)](https://supermarket.chef.io/cookbooks/tomcat)

Provides resources for installing Tomcat and managing the Tomcat service for use in wrapper cookbooks. Installs Tomcat from tarballs on the Apache.org website and installs the appropriate configuration for your platform's init system.

## Requirements

### Platforms

- Debian / Ubuntu derivatives
- RHEL and derivatives
- Fedora
- openSUSE / SUSE Linux Enterprises

### Chef

- Chef 12.1+

### Cookbooks

- compat_resource

## Usage

Due to the complexity of Tomcat cookbooks it's not possible to create an attribute driven cookbook that solves everyone's problems. Instead this cookbook provides resources for installing Tomcat and managing the Tomcat service, which are best used in your own wrapper cookbook. The best way to understand how this could be used is to look at the helloworld test recipe located at https://github.com/chef-cookbooks/tomcat/blob/master/test/cookbooks/test/recipes/helloworld_example.rb

## Resources (providers)

### tomcat_install

tomcat_install installs an instance of the tomcat binary direct from Apache's mirror site. As distro packages are not used we can easily deploy per-instance installations and any version available on the Apache archive site can be installed.

#### properties

- `version`: The version to install. Default: 8.0.43
- `install_path`: Full path to the install directory. Default: /opt/tomcat_INSTANCENAME_VERSION
- `tarball_base_uri`: The base uri to the apache mirror containing the tarballs. Default: '<http://archive.apache.org/dist/tomcat/>'
- `checksum_base_uri`: The base uri to the apache mirror containing the md5 file. Default: '<http://archive.apache.org/dist/tomcat/>'
- `verify_checksum`: Whether the checksum should be verified against `checksum_base_uri`.  Default: `true`.
- `dir_mode`: Directory permissions of the `install_path`. Default: `'0750'`.
- `tarball_uri`: The complete uri to the tarball. If specified would override (`tarball_base_uri` and `checksum_base_uri`). checksum will be loaded from "#{tarball_uri}.md5". This attribute is useful, if you are hosting tomcat tarballs from artifact repositories such as nexus.
- `tarball_path`: Local path on disk to the tarball.  If the file does not exist, or the checksum does not match, it will be downloaded from `tarball_uri`.
- `tarball_validate_ssl`: Validate the SSL certificate, if `tarball_uri` is using HTTPS. Default `true`.
- `exclude_docs`: Exclude ./webapps/docs from installation. Default `true`.
- `exclude_examples`: Exclude ./webapps/examples from installation. Default `true`.
- `exclude_manager`: Exclude ./webapps/manager from installation. Default: `false`.
- `exclude_hostmanager`: Exclude ./webapps/host-manager from installation. Default: `false`.

#### example

Install an Tomcat 8.0.36 instance named 'helloworld' to /opt/tomcat_helloworld_8_0_36/ with a symlink at /opt/tomcat_helloworld/

```ruby
tomcat_install 'helloworld' do
  version '8.0.36'
end
```

Install an Tomcat instance named 'helloworld' from a local tarball to /opt/tomcat_helloworld_8_0_36/ with a symlink at /opt/tomcat_helloworld/
```ruby
tomcat_install 'helloworld' do
  version '8.0.36'
  verify_checksum false
  tarball_path '/tmp/apache-tomcat-8.0.36.tar.gz'
end
```

### tomcat_service

tomcat_service sets up the installed tomcat instance to run using the appropriate init system (sys-v, upstart, or systemd)

#### properties

- `install_path`: Full path to the install directory. Default: /opt/tomcat_INSTANCENAME
- `env_vars`: An array of hashes containing the environmental variables for Tomcat's setenv.sh script. Note: If CATALINA_BASE is not passed it will automatically be added as the first item in the array. Default: [ {'CATALINA_BASE' => '/opt/INSTANCE_NAME/'}, {'CATALINA_PID' => '$CATALINA_BASE/bin/tomcat.pid'} ]
- `sensitive`: Excludes diffs that may expose ENV values from the chef-client logs. Default: `false`

#### actions

- `start`
- `stop`
- `enable`
- `disable`
- `restart`

#### example

```ruby
tomcat_service 'helloworld' do
  action :start
  env_vars [{ 'CATALINA_PID' => '/my/special/path/tomcat.pid' }]
end
```

## License & Authors

- Author: Tim Smith ([tsmith@chef.io](mailto:tsmith@chef.io))

```text
Copyright:: 2010-2016, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
