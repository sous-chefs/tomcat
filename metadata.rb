name             'tomcat'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Installs/Configures tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.17.3'

depends 'java'
depends 'openssl'
depends 'yum-epel'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'amazon'
supports 'oracle'
supports 'scientific'
supports 'opensuse'

recipe 'tomcat::default', 'Installs and configures Tomcat'
recipe 'tomcat::users', 'Setup users and roles for Tomcat'

source_url 'https://github.com/chef-cookbooks/tomcat' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/tomcat/issues' if respond_to?(:issues_url)
