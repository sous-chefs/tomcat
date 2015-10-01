actions :set
default_action :set

attribute :JvmMs,
          kind_of: String, # in megabytes
          required: true
attribute :JvmMx,
          kind_of: String, # in megabytes
          required: true
attribute :JvmSs,
          kind_of: String, # in kilobytes
          required: true
attribute :PermSize,
          kind_of: String # in megabytes
attribute :MaxPermSize,
          kind_of: String # in megabytes
attribute :jvm_registry_key,
          kind_of: String, default: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Apache Software Foundation\\Procrun 2.0\\Tomcat6\\Parameters\\Java'
attribute :java_options,
          kind_of: String,
          required: true # pass through for user defined (additional) java options
