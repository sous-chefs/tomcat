name              'tomcat'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs Apache Tomcat and manages the service'
source_url        'https://github.com/sous-chefs/tomcat'
issues_url        'https://github.com/sous-chefs/tomcat/issues'
chef_version      '>= 13'
version           '4.2.0'

%w(ubuntu debian redhat centos suse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end
