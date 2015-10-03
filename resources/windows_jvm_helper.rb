actions :set
default_action :set

attribute :initial_java_heap_size,
          kind_of: String,
          default: '128M'
attribute :maximum_java_heap_size,
          kind_of: String,
          default: '256M'
attribute :thread_stack_size,
          kind_of: String,
          default: '2048K'
attribute :permanent_generation_size,
          kind_of: String
attribute :maximum_permanent_generation_size,
          kind_of: String
attribute :jvm_registry_key,
          kind_of: String,
          default: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Apache Software Foundation\\Procrun 2.0\\Tomcat6\\Parameters\\Java'
attribute :java_options,
          kind_of: String,
          required: true # pass through for user defined (additional) java options
