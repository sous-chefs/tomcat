# This method should be used at the start of every recipe that would need to use the below attributes,
# in an attempt to solve #89, #102, #129, #148 and #174.
# Any cookbook attribute that uses the value of another attribute to calculate its own value (derived)
# should be included in this method, so that the calculation of the value takes place at runtime of the recipe.
# The reason is simple: Due to how attribute precedence works in Chef, when an attribute is overriden, it is not always
# the case that the derived attributes will use the correct value of the original attribute to calculate their own.
# This depends on how the attribute has been overriden (cookbook attributes, role, environment, etc.)
# See [this](https://christinemdraper.wordpress.com/2014/10/06/avoiding-the-possible-pitfalls-of-derived-attributes/) for a detailed explanation.

def set_derived_vars
  case node['platform_family']
  when 'rhel', 'fedora'
    suffix = node['tomcat']['base_version'].to_i < 7 ? node['tomcat']['base_version'] : ''

    node.default_unless['tomcat']['base_instance'] = "tomcat#{suffix}"
    node.default_unless['tomcat']['user'] = 'tomcat'
    node.default_unless['tomcat']['group'] = 'tomcat'
    node.default_unless['tomcat']['home'] = "/usr/share/tomcat#{suffix}"
    node.default_unless['tomcat']['base'] = "/usr/share/tomcat#{suffix}"
    node.default_unless['tomcat']['config_dir'] = "/etc/tomcat#{suffix}"
    node.default_unless['tomcat']['log_dir'] = "/var/log/tomcat#{suffix}"
    node.default_unless['tomcat']['tmp_dir'] = "/var/cache/tomcat#{suffix}/temp"
    node.default_unless['tomcat']['work_dir'] = "/var/cache/tomcat#{suffix}/work"
    node.default_unless['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
    node.default_unless['tomcat']['webapp_dir'] = "/var/lib/tomcat#{suffix}/webapps"
    node.default_unless['tomcat']['keytool'] = 'keytool'
    node.default_unless['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
    node.default_unless['tomcat']['endorsed_dir'] = "#{node['tomcat']['lib_dir']}/endorsed"
    node.default_unless['tomcat']['packages'] = ["tomcat#{suffix}"]
    node.default_unless['tomcat']['deploy_manager_packages'] = ["tomcat#{suffix}-admin-webapps"]
  when 'debian'
    node.default_unless['tomcat']['user'] = "tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['group'] = "tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['home'] = "/usr/share/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['base'] = "/var/lib/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['config_dir'] = "/etc/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['log_dir'] = "/var/log/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['tmp_dir'] = "/tmp/tomcat#{node['tomcat']['base_version']}-tmp"
    node.default_unless['tomcat']['work_dir'] = "/var/cache/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
    node.default_unless['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node['tomcat']['base_version']}/webapps"
    node.default_unless['tomcat']['keytool'] = 'keytool'
    node.default_unless['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
    node.default_unless['tomcat']['endorsed_dir'] = "#{node['tomcat']['lib_dir']}/endorsed"
  when 'smartos'
    node.default_unless['tomcat']['user'] = 'tomcat'
    node.default_unless['tomcat']['group'] = 'tomcat'
    node.default_unless['tomcat']['home'] = '/opt/local/share/tomcat'
    node.default_unless['tomcat']['base'] = '/opt/local/share/tomcat'
    node.default_unless['tomcat']['config_dir'] = '/opt/local/share/tomcat/conf'
    node.default_unless['tomcat']['log_dir'] = '/opt/local/share/tomcat/logs'
    node.default_unless['tomcat']['tmp_dir'] = '/opt/local/share/tomcat/temp'
    node.default_unless['tomcat']['work_dir'] = '/opt/local/share/tomcat/work'
    node.default_unless['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
    node.default_unless['tomcat']['webapp_dir'] = '/opt/local/share/tomcat/webapps'
    node.default_unless['tomcat']['keytool'] = '/opt/local/bin/keytool'
    node.default_unless['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
    node.default_unless['tomcat']['endorsed_dir'] = "#{node['tomcat']['home']}/lib/endorsed"
    node.default_unless['tomcat']['packages'] = ['apache-tomcat']
    node.default_unless['tomcat']['deploy_manager_packages'] = []
  when 'suse'
    node.default_unless['tomcat']['base_instance'] = 'tomcat'
    node.default_unless['tomcat']['user'] = 'tomcat'
    node.default_unless['tomcat']['group'] = 'tomcat'
    node.default_unless['tomcat']['home'] = '/usr/share/tomcat'
    node.default_unless['tomcat']['base'] = '/usr/share/tomcat'
    node.default_unless['tomcat']['config_dir'] = '/etc/tomcat'
    node.default_unless['tomcat']['log_dir'] = '/var/log/tomcat'
    node.default_unless['tomcat']['tmp_dir'] = '/var/cache/tomcat/temp'
    node.default_unless['tomcat']['work_dir'] = '/var/cache/tomcat/work'
    node.default_unless['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
    node.default_unless['tomcat']['webapp_dir'] = '/srv/tomcat/webapps'
    node.default_unless['tomcat']['keytool'] = 'keytool'
    node.default_unless['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
    node.default_unless['tomcat']['endorsed_dir'] = "#{node['tomcat']['lib_dir']}/endorsed"
    node.default_unless['tomcat']['packages'] = ['tomcat']
    node.default_unless['tomcat']['deploy_manager_packages'] = ['tomcat-admin-webapps']
  else
    node.default_unless['tomcat']['user'] = "tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['group'] = "tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['home'] = "/usr/share/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['base'] = "/var/lib/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['config_dir'] = "/etc/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['log_dir'] = "/var/log/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['tmp_dir'] = "/tmp/tomcat#{node['tomcat']['base_version']}-tmp"
    node.default_unless['tomcat']['work_dir'] = "/var/cache/tomcat#{node['tomcat']['base_version']}"
    node.default_unless['tomcat']['context_dir'] = "#{node['tomcat']['config_dir']}/Catalina/localhost"
    node.default_unless['tomcat']['webapp_dir'] = "/var/lib/tomcat#{node['tomcat']['base_version']}/webapps"
    node.default_unless['tomcat']['keytool'] = 'keytool'
    node.default_unless['tomcat']['lib_dir'] = "#{node['tomcat']['home']}/lib"
    node.default_unless['tomcat']['endorsed_dir'] = "#{node['tomcat']['lib_dir']}/endorsed"
  end

  # finally, set these, if they've not been set already
  node.default_unless['tomcat']['base_instance'] = "tomcat#{node['tomcat']['base_version']}"
  node.default_unless['tomcat']['packages'] = ["tomcat#{node['tomcat']['base_version']}"]
  node.default_unless['tomcat']['deploy_manager_packages'] = ["tomcat#{node['tomcat']['base_version']}-admin"]
end
