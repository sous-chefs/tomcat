# tomcat Cookbook CHANGELOG

This file is used to list changes made in each version of the tomcat cookbook.

## 2.5.0 (2017-05-02)

- Move the action_class after the actions to workaround a 12.5/12.6 bug
- Fix HTTPS checksums add tarball_validate_ssl param
- Use class_eval for chef 12.5/12.6 compatibility
- Allow skipping the download of the checksum entirely for certain tarball hosting scenarios
- Add tarball_path property, and allow for local tarballs provided outside of this resource.
- Properly place the helper methods into a module so we don't polute the global namespace
- Update the default Tomcat release to 8.0.43
- Remove unnecessary configs for foodcritic and rubocop
- Use a SPDX standard license string
- Fix catalina_base ENV var injection for Chef 13
- Add new `dir_mode` property to set the installation directory permission

## 2.4.0 (2017-03-24)

- Updated chef_version in the metadata to not fail metadata parsing on older chef clients
- Switch to Delivery local for testing from Rake
- Rename the Kitchen Dokken config and update the platforms we test on / config of those platforms
- Simplify how we wire up the resources so we no longer have to specify the underlying init systems of each OS, but instead let chef determine when we're on a systemd vs. upstart vs sys-v system
- Remvove DNF compat recipe in Test Kitchen and the need for the yum cookbook
- Remove sensitive properties that caused deprecation warnings. Sensitive can be set on any resource and defining it in the resource is not necessary
- Add copyright / license headers to the resources

## 2.3.4 (2016-11-28)

- Set tomcat_group in service_sysv_init.rb, for issue 275

## 2.3.3 (2016-10-24)

- Depend on the latest compat_resource
- Remove a few LWRP-isms that were pointed out

## 2.3.2 (2016-08-24)

- Use /bin/false as the shell for the service user
- Don't remove existing users from groups
- Wait 2 seconds before trying to restart the service again with systemd
- Install perl-Getopt-Long-Descriptive on suse systems using the sys-v provider
- Version is not a required attribute in tomcat_install since we have a default
- Lazily eval the install_path vs. helper method to reduce some code complexity in the custom resources
- Use improved Rakefile with better failing + supermarket task. Switch Travis to test via Rake as well
- Use the new built in formatter in inspec instead of the docs formatter
- Update the Kitchen config to test on updated platforms and to use the current chef release vs. stable so we pull in Chef 12.14 which fixes user/group issues on opensuse 13.X
- Clarify that we require Chef 12.1 not 12.0
- Fix bad platform setting in the Chefspecs
- Reduce noisy warnings during Chefspec runs
- Fix inspec tests to pass

## v2.3.1 (2016-07-05)

- Fix specifying user/group on init based installs
- Fix upstart to properly reload the config when restarting
- Avoid exit status 4 errors when restarting on init based systems
- Support pulling the tomcat tarball from https based mirrors

## v2.3.0 (2016-06-27)

- Allow specifying the tomcat user/group in the tomcat_install and tomcat_service resources instead of using the automatically generated values

## v2.2.3 (2016-06-25)

- Fixed the sys-v init scripts to have a unique "provides" line, which was causing problems on Debian 7
- Fixed specifying the specific tomat_service resource in order to use non system default init systems (ex: sys-v on a systemd system)
- Fixed restart actions to properly pass restart instead of stop and then start
- The Tomcat services are now restarted when the ENV values are updated
- Use tomcat_service_sysvinit now works on fedora
- Passing the SHUTDOWN_WAIT ENV value now works correctly

## v2.2.2 (2016-06-23)

- Allow excluding ENV values from logs by setting `sensitive` property on the tomcat_service resource

## v2.2.1 (2016-06-22)

- Fix restarts on init systems
- Allow setting SHUTDOWN_WAIT time in the ENV file
- Add Chef 12 requirement to the metadata

## v2.2.0 (2016-06-19)

- Add a new `tarball_uri` property to the install resource to allow specifying an absolute URI for the download tar.gz file.
- Add new resource name aliases to the individual service resources. This allows calling tomcat_service_systemd, tomcat_service_upstart, or tomcat_service_sysvinit to force the init type you desire
- Update the default Tomcat version to install to 8.0.36
- Increase the compat_resource cookbook dependency from 12.9 to 12.10 to resolve odd failures in 12.9
- Added additional suse platforms to the metadata
- Removed Chef 11 compatibility code from the metadata file
- Update test deps to the latest
- Switched to cookstyle for simplified Ruby linting

## v2.1.3 (2016-05-10)

- Fix regression in the service resource on suse

## v2.1.2 (2016-05-06)

- Restore Amazon Linux compatibility

## v2.1.1 (2016-05-05)

- Create the tomcat user as a system user
- Use platform_family instead of platform when defining the resources so we can easily support opensuse leap.

## v2.1.0 (2016-04-18)

- Added proper systemd support for opensuse 13+
- Fixed all systemd platforms to use /etc/systemd vs. /lib/systemd for storing unit files
- Create the init files on the enable action so that you can enable, but not start the service

## v2.0.5 (2016-04-15)

- Fixed the install resource to properly remove the ROOT app that ships in the tarball when exclude_examples property is set
- Add IBM zLinux as a supported platform in the metadata

## v2.0.4 (2016-04-13)

- Fixed a copy / paste mistake in the chefspec matchers

## v2.0.3 (2016-04-01)

- Fix Tomcat 7 installations on systemd not starting by changing the catalina.sh action from start to run
- Fix bug where Tomcat 7 and Tomcat 8 instances could not be installed on the same host
- Switch from sha1 to md5 checksums as older Tomcat releases didn't include SHA1 checksums
- rename sha1_base_path property to checksum_base_path since we're using MD5s now. The existing property name will continue to work for backwards compatibility
- Add start/stop runlevel header to the init script
- Reload the systemd unit file if it changes
- Don't give the tomcat user a valid shell

## v2.0.2 (2016-03-16)

- Avoid namespace conflicts with other cookbooks that were causing failures. Thanks @alappe and @EdSingleton for providing the information to track this down.
- Fix a typo that prevented passing environmental directives with systemd. - @nickptrvc
- Depend on the latest compat_resource to avoid warnings

## v2.0.1 (2016-03-07)

- Fix HTTP download of the Tomcat artifact to use a proxy server if ENV variables are defined @petracvv
- Fix a custom resource property typo in the readme @fallwith

## v2.0.0 (2016-03-02)

COMPATIBILIY WARNING!!!! This version removes the existing recipes, attributes, and instance provider in favor of the new tomcat_install and tomcat_service resources. Why not just leave them in place? Well unfortunately they were utterly broken for anything other than the most trivial usage. Rather than continue the user pain we've opted to remove them and point users to a more modern installation method. If you need the legacy installation methods simply pin to the 1.3.0 release.

- Add usage documentation for the new resources
- Add chefspec matchers for the new resources
- Add kitchen-inspec to the Gemfile for testing

## v1.3.0 (2016-02-25)

- Resolve missing directory warnings on Debian based systems that use systemd (Debian 8+ and Ubuntu 15.10+)
- Add testing and support for openSUSE 13.X
- Expand the platforms tested in the kitchen.yml file
- Remove the zypper_refresh cookbook. The zypper cookbook on the supermarket should be used instead
- Resolved foodcritic warnings in the instance provider

## v1.2.1 (2016-02-25)

- Added restart and enable actions to tomcat_service resource
- Fixed init scripts trying to use /var/log/tomcat_INSTANCE dir that is no longer created
- If a custom path is provided the trailing / will be stripped to prevent // in scripts
- Start action in tomcat_service now starts the service instead of starting / enabling the service
- Stop and disable actions no longer create the init script first. Instead they only perform their actions if the init script exists

## v1.2.0 (2016-02-25)

- Added systemd and upstart support to tomcat_service custom resource
- tomcat_install no longer creates a logs dir in /var/logs/ as logging is up to the users
- custom paths no longer throw an error in tomcat_install
- path property in tomcat_install is now renamed install_path to match the tomcat_service resource
- the test cookbook now installs two different instances and includes the java setup the same way a wrapper cookbook would
- ubuntu 15.10 has been removed from the Test Kitchen config since there is no published box for this version yet
- debian 8 is now properly identified as a systemd based system
- inspec tests for the test cookbook updated to pass
- nil default properties have been removed to resolve Chef deprecation warnings

## v1.1.0 (2016-02-23)

- Included new experimental tomcat_install and tomcat_service custom resource for pulling down any specified tomcat release from the Apache Org site and managing the service. This allows for running any Tomcat release on any distro (no more packages) and will eventually replace the existing attribute and provider config methods
- Added compat_resource as a cookbook dependency for the new custom resources
- Depend on java cookbook >= 1.36 to allow for OpenJDK 1.8 installs along with many bugfixes
- Test Kitchen now tests the new providers in Travis CI using kitchen-dokken (docker)
- Existing test suites have been removed as that functionality will be deprecated in the near future
- UseConcMarkSweepGC is no longer hard coded in the Tomcat 6 config. Instead this is part of the JAVAOPTS attribute so it can be overwritten
- Added uriencoding to the instance provider. See the readme for details
- Added new attribute for the ajp listen IP. See the readme for details

## v1.0.1 (2015-12-01)

- Resolved a missing method error in the instance provider

## v1.0.0 (2015-11-30)

- BREAKING: This cookbook now requires Chef 12.1+ due to the use of multipackage installs
- Added support for OpenSUSE
- Added a new attribute ['tomcat']['client_auth'] to enable client auth
- Added new attribute ['tomcat']['ajp_redirect_port'] for specifying a redirect port in server.xml
- Added new attributes: ['tomcat']['proxy_name'], ['tomcat']['secure'], and ['tomcat']['scheme'] to support proxying
- Added new attribute ['tomcat']['ciphers'] to add SSL ciphers to the server.xml
- Added a new attribute ['tomcat']['ssl_enabled_protocols'] to add SSL protocols to the server.xml
- Added new attribute ['tomcat']['uriencoding'] to add uriencoding to server.xml with a default of 'UTF-8'
- Added new attribute ['tomcat']['environment'] to add environmental variables to the sysconfig on RHEL platforms
- Fixed EPEL tomcat when an empty string is provided as the Tomcat version
- Fixed generation of keystore file in the instance provider
- Fixed initialization of a constant twice
- Added back the automatic service restarts on the tomcat.conf changes
- Don't include the JasperListener if less than Tomcat 8
- Removed a hardcoded service name in the users recipe
- Improved requirements section of the readme and added travis / supermarket badges
- Added serverspec tests for Test Kitchen
- Added new source_url and issues_url metadata for supermarket
- Updated the Gemfile with the latest deps
- Updated Berskfile to the 3.X+ format
- Updated contributing, testing, and maintainers docs
- Added the chef standard rubocop config and resolve all warnings
- Updated the Kitchen CI config to work with the latest platforms
- Updated .gitignore and added a chefignore to limit files uploaded to the server
- Added a .foodcritic file to exclude rules

## v0.17.3 (2015-02-22)

- Fix package names and directories for Tomcat 7 on RHEL

## v0.17.2 (2015-02-18)

- reverting OpenSSL module namespace change

## v0.17.1 (2015-02-17)

- updating to use the latest openssl

## v0.17.0 (2014-12-11)

- Removed installation of Java

## v0.16.2 (2014-08-06)

- 80 - Fix broken server.xml when not using ssl

## v0.16.0 (2014-06-11)

- 70 - [COOK-4332] Support running multiple instance
- 73 - Be pedantic on where the data bag secret should be placed.

## v0.15.12 (2014-04-23)

- [COOK-3745] - Scientific Linux support for Tomcat
- [COOK-4573] - Oracle Linux support for Tomcat
- [COOK-4574] - genkeypair is not a valid parameter to keytool
- [COOK-4575] - update test harness for Ubuntu 14.04'

## v0.15.10 (2014-03-27)

- [COOK-4487] - Use tomcat group in /etc/default template

## v0.15.8 (2014-03-19)

- [COOK-4209] - Remove "Host element/XML Validation" in tomcat 7 and above

## v0.15.6 (2014-03-12)

- [COOK-4301] - Duplicate truststore settings added to java_options every chef-client run

## v0.15.4 (2014-02-18)

### Improvement

- **[COOK-4258](https://tickets.chef.io/browse/COOK-4258)** - tomcat: support for Apache mod_jk load balancing with jvmRoute
- **[COOK-3370](https://tickets.chef.io/browse/COOK-3370)** - Don't install the tomcat manager apps package if we're not going to use it

### Bug

- **[COOK-4257](https://tickets.chef.io/browse/COOK-4257)** - tomcat: broken on SmartOS SmartMachine images 13.3.0+
- **[COOK-4097](https://tickets.chef.io/browse/COOK-4097)** - default["tomcat"]["keytool"] is set to non-existent file on Debian/Ubuntu

## v0.15.2

### New Feature

- [COOK-3622] - Add support for Amazon platform to the tomcat cookbook.

### Bug

- [COOK-3379] - Only regenerate keystore and restart tomcat when source files change
- [COOK-1599] - Add retry and delay to tomcat service definition

## v0.15.0

### Improvement

- **[COOK-3565](https://tickets.chef.io/browse/COOK-3565)** - Make server.xml connectors maxThreads params configurable via attributes

### New Feature

- **[COOK-3333](https://tickets.chef.io/browse/COOK-3333)** - Add SmartOS support

## v0.14.4

### Bug

- **[COOK-3378](https://tickets.chef.io/browse/COOK-3378)** - Use keystore in the port 8443 connector
- **[COOK-3204](https://tickets.chef.io/browse/COOK-3204)** - Fix hard-coded path to `tomcat-users.xml`
- **[COOK-3203](https://tickets.chef.io/browse/COOK-3203)** - Support "reload" on Ubuntu 12.04

### Improvement

- **[COOK-3195](https://tickets.chef.io/browse/COOK-3195)** - Fix error for creating endorsed dir
- **[COOK-3083](https://tickets.chef.io/browse/COOK-3083)** - Add an attribute to lib directory

## v0.14.2

### Bug

- [COOK-3165]: Typo in tomcat attributes/default.rb file for `webapp_dir` attribute on Debian/Ubuntu

## v0.14.0

### Sub-task

- [COOK-1808]: Add Support for Tomcat 7 (ubuntu 12.04+, debian 7+)

## v0.13.0

### Improvement

- [COOK-2999]: Attributes are "set" and not "default"

### Bug

- [COOK-2421]: Correct name of cookbook in attributes/default.rb
- [COOK-2838]: Fix foodcritic warnings in tomcat cookbook

### New Feature

- [COOK-2422]: Support disabling Tomcat auth
- [COOK-2425]: Add SSL connector support
- [COOK-2533]: Ability to set loglevel
- [COOK-2736]: Add CATALINA_OPTS for Tomcat start/run options

## v0.12.0

- [COOK-1736] - Add AUTHBIND attribute

## v0.11.0

- [COOK-1499] - manage tomcat users

## v0.10.4

- [COOK-1110] - remove deprecated (by upstream) jpackage recipe
