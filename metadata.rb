name             'tomcat'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs and Apache Tomcat and manages the service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.3'

depends 'compat_resource', '>= 12.9.0'

%w(ubuntu debian redhat centos suse opensuse scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/tomcat' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/tomcat/issues' if respond_to?(:issues_url)
