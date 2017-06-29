name             'tomcat'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'Installs Apache Tomcat and manages the service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.5.2'

depends 'compat_resource', '>= 12.16'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/tomcat'
issues_url 'https://github.com/chef-cookbooks/tomcat/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
