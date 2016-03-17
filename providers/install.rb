use_inline_resources

def whyrun_supported?
  true
end

# break apart the version string to find the major version
def major_version
  @@major_version ||= new_resource.version.split('.')[0]
end

# the install path of this instance of tomcat
def full_install_path
  if new_resource.install_path
    new_resource.install_path
  else
    @@path ||= "/opt/tomcat_#{new_resource.instance_name}_#{new_resource.version.tr('.', '_')}/"
  end
end

# build the extraction command based on the passed properties
def extraction_command
  cmd = "tar -xzf #{Chef::Config['file_cache_path']}/apache-tomcat-#{new_resource.version}.tar.gz -C #{full_install_path} --strip-components=1"
  cmd << " --exclude='*webapps/examples*'" if new_resource.exclude_examples
  cmd << " --exclude='*webapps/ROOT/*'" if new_resource.exclude_examples
  cmd << " --exclude='*webapps/docs*'" if new_resource.exclude_docs
  cmd << " --exclude='*webapps/manager*'" if new_resource.exclude_manager
  cmd << " --exclude='*webapps/host-manager*'" if new_resource.exclude_hostmanager
  cmd
end

# ensure the version is X.Y.Z format
def validate_version
  unless new_resource.version =~ /\d+.\d+.\d+/
    Chef::Log.fatal("The version must be in X.Y.Z format. Passed value: #{new_resource.version}")
    raise
  end
end

# fetch the sha1 checksum from the mirrors
# we have to do this since the sha256 chef expects isn't hosted
def fetch_checksum
  uri = URI.join(new_resource.sha1_base_path, "tomcat-#{major_version}/v#{new_resource.version}/bin/apache-tomcat-#{new_resource.version}.tar.gz.sha1")
  request = Net::HTTP.new(uri.host, uri.port)
  response = request.get(uri)
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
def validate_checksum(file_to_check)
  desired = fetch_checksum
  actual = Digest::SHA1.hexdigest(::File.read(file_to_check))

  if desired == actual
    true
  else
    Chef::Log.fatal("The checksum of the tomcat tarball on disk (#{actual}) does not match the checksum provided from the mirror (#{desired}). Renaming to #{::File.basename(file_to_check)}.bad")
    ::File.rename(file_to_check, "#{file_to_check}.bad")
    raise
  end
end

# build the complete tarball URI and handle basepath with/without trailing /
def tarball_uri
  uri = ''
  uri << new_resource.tarball_base_path
  uri << '/' unless uri[-1] == '/'
  uri << "tomcat-#{major_version}/v#{new_resource.version}/bin/apache-tomcat-#{new_resource.version}.tar.gz"
  uri
end

action :install do
  validate_version

  # some RHEL systems lack tar in their minimal install
  package 'tar'

  remote_file "apache #{new_resource.version} tarball" do
    source tarball_uri
    path "#{Chef::Config['file_cache_path']}/apache-tomcat-#{new_resource.version}.tar.gz"
    verify { |file| validate_checksum(file) }
  end

  directory 'tomcat install dir' do
    mode '0750'
    path full_install_path
    recursive true
  end

  execute 'extract tomcat tarball' do
    command extraction_command
    action :run
    creates ::File.join(full_install_path, 'LICENSE')
  end

  group new_resource.group do
    action :create
  end

  user new_resource.owner do
    gid new_resource.group
    action :create
  end

  # make sure the instance's user owns the instance install dir
  execute "chown install dir as #{new_resource.owner}" do
    command "chown -R #{new_resource.owner}:#{new_resource.group} #{full_install_path}"
    action :run
    not_if { Etc.getpwuid(::File.stat("#{full_install_path}/LICENSE").uid).name == new_resource.owner }
  end

  # create a link that points to the latest version of the instance
  link "/opt/tomcat_#{new_resource.instance_name}" do
    to full_install_path
  end

  if new_resource.service_create
    tomcat_service new_resource.instance_name do
      user new_resource.owner
      group new_resource.group
      action new_resource.service_action
    end
  end
end
