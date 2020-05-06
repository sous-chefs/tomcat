# tomcat Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/tomcat.svg?style=flat)](https://supermarket.chef.io/cookbooks/tomcat)
[![CI State](https://github.com/sous-chefs/tomcat/workflows/ci/badge.svg)](https://github.com/sous-chefs/tomcat/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides resources for installing Tomcat and managing the Tomcat service for use in wrapper cookbooks. Installs Tomcat from tarballs on the Apache.org website and installs the appropriate configuration for your platform's init system.

## Requirements

### Platforms

- Debian / Ubuntu derivatives
- RHEL and derivatives
- Fedora
- openSUSE / SUSE Linux Enterprises

### Chef

- Chef 13+

### Cookbooks

- none

## Usage

Due to the complexity of Tomcat cookbooks it's not possible to create an attribute driven cookbook that solves everyone's problems. Instead this cookbook provides resources for installing Tomcat and managing the Tomcat service, which are best used in your own wrapper cookbook. The best way to understand how this could be used is to look at the helloworld test recipe located at <https://github.com/chef-cookbooks/tomcat/blob/master/test/cookbooks/test/recipes/helloworld_example.rb>

## Resources

### tomcat_install

tomcat_install installs an instance of the tomcat binary direct from Apache's mirror site. As distro packages are not used we can easily deploy per-instance installations and any version available on the Apache archive site can be installed.

#### properties

- `version`: The version to install. Default: 8.5.54
- `install_path`: Full path to the install directory. Default: /opt/tomcat_INSTANCENAME_VERSION
- `tarball_base_uri`: The base uri to the apache mirror containing the tarballs. Default: '<http://archive.apache.org/dist/tomcat/>'
- `checksum_base_uri`: The base uri to the apache mirror containing the md5 or sha512 file. Default: '<http://archive.apache.org/dist/tomcat/>'
- `verify_checksum`: Whether the checksum should be verified against `checksum_base_uri`. Default: `true`.
- `dir_mode`: Directory permissions of the `install_path`. Default: `'0750'`.
- `tarball_uri`: The complete uri to the tarball. If specified would override (`tarball_base_uri` and `checksum_base_uri`). checksum will be loaded from "#{tarball_uri}.{md5,sha512}". This attribute is useful, if you are hosting tomcat tarballs from artifact repositories such as nexus. `sha512` sums are used for version constraints: `~> 7.0.84`, `~> 8.0.48`, `~> 8.5.24`, `~> 9.0.10`.
- `tarball_path`: Local path on disk to the tarball. If the file does not exist, or the checksum does not match, it will be downloaded from `tarball_uri`.
- `tarball_validate_ssl`: Validate the SSL certificate, if `tarball_uri` is using HTTPS. Default `true`.
- `exclude_docs`: Exclude ./webapps/docs from installation. Default `true`.
- `exclude_examples`: Exclude ./webapps/examples from installation. Default `true`.
- `exclude_manager`: Exclude ./webapps/manager from installation. Default: `false`.
- `exclude_hostmanager`: Exclude ./webapps/host-manager from installation. Default: `false`.
- `tomcat_user`: User to run tomcat as. Default: `tomcat_INSTANCENAME`
- `tomcat_group`: Group of the tomcat user. Default: `tomcat_INSTANCENAME`
- `tomcat_user_shell`: Shell of the tomcat user. Default: `/bin/false`
- `create_user`: Creates the specified tomcat_user within the OS.  Default `true`.
- `create_group`: Creates the specified tomcat_group within the OS. Default `true`.
- `service_template_source`: Source template file for the sys-v/upstart/systemd service definition. Default: 'init_sysv.erb'
- `service_template_cookbook`: Cookbook from which to source the sys-v/upstart/systemd service definition template. Default: 'tomcat'
- `setenv_template_source`: Source template file for the sys-v 'setenv' file. Default: 'setenv.erb'
- `setenv_template_cookbook`: Cookbook from which to source the sys-v 'setenv' file. Default: 'tomcat'

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
- `service_vars`: An array of hashes containing additional systemd directives when setting up a service under systemd.
- `sensitive`: Excludes diffs that may expose ENV values from the chef-client logs. Default: `false`
- `tomcat_user`: The user the service runs under
- `tomcat_group`: The group the service runs under

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

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
