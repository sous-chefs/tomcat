property :instance_name, String, name_property: true
property :version, String, required: true, default: '8.0.32'
property :path, String, default: nil
property :tarball_base_path, String, default: 'http://archive.apache.org/dist/tomcat/'
property :sha1_base_path, String, default: 'http://archive.apache.org/dist/tomcat/'
property :exclude_docs, kind_of: [TrueClass, FalseClass], default: true
property :exclude_examples, kind_of: [TrueClass, FalseClass], default: true
property :exclude_manager, kind_of: [TrueClass, FalseClass], default: false
property :exclude_hostmanager, kind_of: [TrueClass, FalseClass], default: false

# break apart the version string to find the major version
def major_version
  @@major_version ||= version.split('.')[0]
end

# the install path of this instance of tomcat
def install_path
  if path
    path
  else
    @@install_path ||= "/opt/tomcat_#{instance_name}_#{version.tr('.', '_')}/"
  end
end

# build the extraction command based on the passed properties
def extraction_command
  cmd = "tar -xzf #{Chef::Config['file_cache_path']}/apache-tomcat-#{version}.tar.gz -C #{install_path} --strip-components=1"
  cmd << " --exclude='*webapps/examples*'" if exclude_examples
  cmd << " --exclude='*webapps/ROOT/*'" if exclude_examples
  cmd << " --exclude='*webapps/docs*'" if exclude_docs
  cmd << " --exclude='*webapps/manager*'" if exclude_manager
  cmd << " --exclude='*webapps/host-manager*'" if exclude_hostmanager
  cmd
end

# ensure the version is X.Y.Z format
def validate_version
  unless version =~ /\d+.\d+.\d+/
    Chef::Log.fatal("The version must be in X.Y.Z format. Passed value: #{version}")
    raise
  end
end

# fetch the sha1 checksum from the mirrors
# we have to do this since the sha256 chef expects isn't hosted
def fetch_checksum
  uri = URI.join(sha1_base_path, "tomcat-#{major_version}/v#{version}/bin/apache-tomcat-#{version}.tar.gz.sha1")
  response = Net::HTTP.get_response(uri)
  if response.code != '200'
    Chef::Log.fatal("Fetching the Tomcat tarball checksum at #{uri} resulted in an error #{response.code}")
    raise
  end
  response.body.split(' ')[0]
rescue => e
  Chef::Log.fatal("Could not fetch the checksum due to an error: #{e}")
  raise
end

# validate the mirror checksum against the on disk checksum
# return true if they match. Append .bad to the cached copy to prevent using it next time
def validate_checksum(file)
  desired = fetch_checksum
  actual = Digest::SHA1.hexdigest(::File.read(file))

  if desired == actual
    true
  else
    Chef::Log.fatal("The checksum of the tomcat tarball on disk (#{actual}) does not match the checksum provided from the mirror (#{desired}). Renaming to #{::File.basename(file)}.bad")
    ::File.rename(file, "#{file}.bad")
    raise
  end
end

# build the complete tarball URI and handle basepath with/without trailing /
def tarball_uri
  uri = ''
  uri << tarball_base_path
  uri << '/' unless uri[-1] == '/'
  uri << "tomcat-#{major_version}/v#{version}/bin/apache-tomcat-#{version}.tar.gz"
  uri
end

action :install do
  validate_version

  # some RHEL systems lack tar in their minimal install
  package 'tar'

  remote_file "apache #{version} tarball" do
    source tarball_uri
    path "#{Chef::Config['file_cache_path']}/apache-tomcat-#{version}.tar.gz"
    verify { |file| validate_checksum(file) }
  end

  directory 'tomcat install dir' do
    mode '0750'
    path install_path
    recursive true
  end

  execute 'extract tomcat tarball' do
    command extraction_command
    action :run
    creates ::File.join(install_path, 'LICENSE')
  end

  group "tomcat_#{instance_name}" do
    action :create
  end

  user "tomcat_#{instance_name}" do
    gid "tomcat_#{instance_name}"
    action :create
  end

  # make sure the instance's user owns the instance install dir
  execute "chown install dir as tomcat_#{instance_name}" do
    command "chown -R tomcat_#{instance_name}:root #{install_path}"
    action :run
    not_if { Etc.getpwuid(::File.stat("#{install_path}/LICENSE").uid).name == "tomcat_#{instance_name}" }
  end

  # create a link that points to the latest version of the instance
  link "/opt/tomcat_#{instance_name}" do
    to install_path
  end

  # create the log dir for the instance
  directory '/var/log/tomcat_helloworld' do
    owner "tomcat_#{instance_name}"
    mode '0770'
    recursive true
    action :create
  end
end
