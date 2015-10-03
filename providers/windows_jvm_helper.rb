use_inline_resources

include Chef::DSL::RegistryHelper # needed for the use of registry_get_values

###############################################################################
## action :set
## This action updates the windows registry for the tomcat settings.
#
# In windows, when installed as a service, the java options are registry based.
# PermSize and MaxPermSize are both optional here, but added for completeness.
# They can be safely added to the java_options, and undefined on the node.
###############################################################################
action :set do
  # initial Java heap size
  registry_key new_resource.jvm_registry_key do
    values [{
      name: 'JvmMs',
      type: :dword,
      data: new_resource.initial_java_heap_size
    }]
    action :create
  end

  # maximum Java heap size
  registry_key new_resource.jvm_registry_key do
    values [{
      name: 'JvmMx',
      type: :dword,
      data: new_resource.maximum_java_heap_size
    }]
    action :create
  end

  # thread stack size
  registry_key new_resource.jvm_registry_key do
    values [{
      name: 'JvmSs',
      type: :dword,
      data: new_resource.thread_stack_size
    }]
    action :create
  end

  # These are the defaults for Apache Tomcat on Windows (as a service)
  options_value = %w()
  options_value << "-Dcatalina.home=#{node['tomcat']['base']}"
  options_value << "-Dcatalina.base=#{node['tomcat']['base']}"
  options_value << "-Djava.endorsed.dirs=#{node['tomcat']['endorsed_dir']}"
  options_value << "-Djava.io.tmpdir=#{node['tomcat']['tmp_dir']}"
  options_value << '-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager'
  options_value << "-Djava.util.logging.config.file=#{node['tomcat']['config_dir']}\\logging.properties"

  if !new_resource.permanent_generation_size.nil? && new_resource.permanent_generation_size != ''
    options_value << "-XX:PermSize=#{new_resource.permanent_generation_size}"
  end
  if !new_resource.maximum_permanent_generation_size.nil? && new_resource.maximum_permanent_generation_size != ''
    options_value << "-XX:MaxPermSize=#{new_resource.maximum_permanent_generation_size}"
  end

  # finally add on the passed through java options
  if !new_resource.java_options.nil? && new_resource.java_options != ''
    options_value << new_resource.java_options.split(' ')
  end

  registry_key new_resource.jvm_registry_key do
    values [{
      name: 'Options',
      type: :multi_string,
      data: [options_value]
    }]
    action :create
  end
end
