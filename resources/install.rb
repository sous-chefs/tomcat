actions :install

property :instance_name, String, name_property: true
property :version, String, required: true, default: '8.0.32'
property :install_path, String
property :tarball_base_path, String, default: 'http://archive.apache.org/dist/tomcat/'
property :sha1_base_path, String, default: 'http://archive.apache.org/dist/tomcat/'
property :exclude_docs, kind_of: [TrueClass, FalseClass], default: true
property :exclude_examples, kind_of: [TrueClass, FalseClass], default: true
property :exclude_manager, kind_of: [TrueClass, FalseClass], default: false
property :exclude_hostmanager, kind_of: [TrueClass, FalseClass], default: false
property :owner, kind_of: String, default: lazy {|r| "tomcat_#{r.instance_name}" }
property :group, kind_of: String, default: lazy {|r| "tomcat_#{r.instance_name}" }
property :service_create, kind_of: [TrueClass, FalseClass], default: false
property :service_action, kind_of: Symbol, default: :nothing

def initialize(*args)
  super
  @action = :install
end
